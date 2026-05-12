import 'package:field_ops/core/constants/about_coloring.dart';
import 'package:field_ops/layers/presentation/widgets/card_text.dart';
import 'package:field_ops/layers/presentation/widgets/generale_title.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String firstText ;
  final String secondText ;
  final IconData icon ;
  const CustomCard({super.key, required this.firstText, required this.secondText, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: 0.6, color: inputBorder),
                      ),
                      color: Colors.white,
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 20,
                          top: 20,
                          left: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  icon,
                                  color: primaryBlue,
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                CardText(text: firstText),
                              ],
                            ),
                            SizedBox(height: 8),
                            GeneraleTitle(text: secondText),
                          ],
                        ),
                      ),
                    );
  }
}