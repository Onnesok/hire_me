import 'package:flutter/material.dart';

class ItemGridView extends StatelessWidget {
  final List<String> items;
  final Function(String) onItemTap;
  final Map<String, IconData> serviceIcons;
  final Map<String, Color> serviceColors;

  const ItemGridView({
    required this.items,
    required this.onItemTap,
    required this.serviceIcons,
    required this.serviceColors,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Define colors based on the theme
    final cardColor = isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.6);
    final shadowColor = isDarkMode ? Colors.black : Colors.black.withOpacity(0.6);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Responsive grid layout based on screen width
    double screenWidth = MediaQuery.of(context).size.width;

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 16),
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 1.8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GestureDetector(
          onTap: () => onItemTap(item),
          child: Card(
            color: cardColor,
            shadowColor: shadowColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4, right: 4),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: serviceColors[item] ?? Colors.grey,
                    radius: 22,
                    child: Icon(
                      serviceIcons[item],
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Service name text
                        Text(
                          item,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        // Description text
                        Text(
                          "Tap to explore services of HireMe app. All the services you need is in one place",
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontSize: 8,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}