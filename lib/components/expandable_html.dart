import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

// 1. Define the Expandable Widget
class ExpandableHtmlDescription extends StatefulWidget {
  final String htmlData;
  final int maxLines;
  final TextStyle buttonTextStyle;

  const ExpandableHtmlDescription({
    super.key,
    required this.htmlData,
    this.maxLines = 3,
    required this.buttonTextStyle,
  });

  @override
  State<ExpandableHtmlDescription> createState() =>
      _ExpandableHtmlDescriptionState();
}

class _ExpandableHtmlDescriptionState extends State<ExpandableHtmlDescription> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Determine which version of the HTML widget to display
    final htmlWidget = Html(
      data: widget.htmlData,
      // NOTE: Remove the specific 'fontFamily: "Nunito-Sans"' from here 
      // to rely on the app's default font, as requested.
      style: {
        "body": Style(
          color: Colors.white.withOpacity(.7),
          fontSize: FontSize(11),
          fontWeight: FontWeight.bold,
          lineHeight: LineHeight(1.2),
          // We rely on the theme for fontFamily, but flutter_html can override.
          // If the app's theme is not being picked up, you may need to specify 
          // the desired default font name here.
        ),
        // Add specific HTML tag styles if needed (like the green color)
        "font[color]": Style(
          color: const Color(0xFF397B21), 
          fontWeight: FontWeight.w900,
        ),
      },
    );

    // If the widget is expanded, show the full content
    if (_isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          htmlWidget,
          const SizedBox(height: 5),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = false;
              });
            },
            child: Text(
              'Show less',
              style: widget.buttonTextStyle,
            ),
          ),
        ],
      );
    }

    // If not expanded, use the LayoutBuilder/RichText hack to detect overflow 
    // and limit lines. For HTML, the simplest reliable approach is often to 
    // use a static container height or a controlled RichText widget.
    
    // Using RichText for overflow check and then showing the HTML or an excerpt.
    // However, since the HTML contains complex tags, we'll focus on the visual
    // limitation by checking the underlying text and then displaying the button.
    
    // We can't apply maxLines directly to Html, so we use the first X characters
    // or rely on a wrapper that estimates the height, but that is complex.
    // For a reliable 3-line limit, we use the original text and append '...'
    // while showing the "More" button.
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2. Wrap the HTML widget with a SizedBox to restrict its height 
        // to approximately 3 lines (adjust 45.0 based on your font size/lineHeight)
        SizedBox(
          height: 45.0, 
          child: OverflowBox(
            alignment: Alignment.topLeft,
            maxHeight: double.infinity,
            child: htmlWidget,
          ),
        ),
        const SizedBox(height: 5),
        
        // 3. Show the "More" button
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = true;
            });
          },
          child: Text(
            'More',
            style: widget.buttonTextStyle,
          ),
        ),
      ],
    );
  }
}