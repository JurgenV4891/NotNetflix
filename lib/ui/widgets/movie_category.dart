import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notnetflix/models/movie.dart';

import 'movie_card.dart';

class MovieCategory extends StatelessWidget {
  final String label;
  final List<Movie> movieList;
  final double imageHeight;
  final double imageWidth;
  final Function callback;
  const MovieCategory({
    Key? key,
    required this.imageHeight,
    required this.imageWidth,
    required this.label,
    required this.movieList,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: imageHeight,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              final currentPosition = notification.metrics.pixels;
              // print('CURRENT POSITION = $currentPosition');
              final maxPosition = notification.metrics.maxScrollExtent;
              // print('MAX POSITION = $maxPosition');
              if (currentPosition >= maxPosition / 2) {
                // print('Vous êtes arrivé au bout de la liste ');
                callback();
              }
              return true;
            },
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movieList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: imageWidth,
                  child: movieList.isEmpty
                      ? Center(
                          child: Text(index.toString()),
                        )
                      : MovieCard(movie: movieList[index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
