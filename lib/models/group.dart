import 'package:flutter/material.dart';
import 'post.dart';
import 'user.dart';

class Group {
  final String id;
  final String name;
  final String description;
  final String groupImage;
  final List<User> members;
  final int memberCount;
  final List<Post> posts;
  final int newSpillsCount;
  final bool isJoined;
  final GroupCategory category;

  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.groupImage,
    required this.members,
    required this.memberCount,
    required this.posts,
    required this.newSpillsCount,
    this.isJoined = false,
    required this.category,
  });

  Group copyWith({
    String? id,
    String? name,
    String? description,
    String? groupImage,
    List<User>? members,
    int? memberCount,
    List<Post>? posts,
    int? newSpillsCount,
    bool? isJoined,
    GroupCategory? category,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      groupImage: groupImage ?? this.groupImage,
      members: members ?? this.members,
      memberCount: memberCount ?? this.memberCount,
      posts: posts ?? this.posts,
      newSpillsCount: newSpillsCount ?? this.newSpillsCount,
      isJoined: isJoined ?? this.isJoined,
      category: category ?? this.category,
    );
  }
}

enum GroupCategory {
  music,
  popCulture,
  news,
  politics,
  entertainment,
  hipHop,
  sports,
  technology,
  gaming,
  fashion,
  food,
  travel,
  art,
  science,
  books,
  movies,
  television,
  fitness,
  beauty,
  business
}

extension GroupCategoryExtension on GroupCategory {
  String get displayName {
    switch (this) {
      case GroupCategory.popCulture:
        return 'Pop Culture';
      case GroupCategory.hipHop:
        return 'Hip Hop';
      default:
        return toString().split('.').last[0].toUpperCase() + 
               toString().split('.').last.substring(1);
    }
  }

  IconData get icon {
    switch (this) {
      case GroupCategory.music:
        return Icons.music_note;
      case GroupCategory.popCulture:
        return Icons.stars;
      case GroupCategory.news:
        return Icons.article;
      case GroupCategory.politics:
        return Icons.gavel;
      case GroupCategory.entertainment:
        return Icons.movie;
      case GroupCategory.hipHop:
        return Icons.headphones;
      case GroupCategory.sports:
        return Icons.sports_basketball;
      case GroupCategory.technology:
        return Icons.computer;
      case GroupCategory.gaming:
        return Icons.gamepad;
      case GroupCategory.fashion:
        return Icons.shopping_bag;
      case GroupCategory.food:
        return Icons.restaurant;
      case GroupCategory.travel:
        return Icons.flight;
      case GroupCategory.art:
        return Icons.palette;
      case GroupCategory.science:
        return Icons.science;
      case GroupCategory.books:
        return Icons.book;
      case GroupCategory.movies:
        return Icons.movie_creation;
      case GroupCategory.television:
        return Icons.tv;
      case GroupCategory.fitness:
        return Icons.fitness_center;
      case GroupCategory.beauty:
        return Icons.face;
      case GroupCategory.business:
        return Icons.business;
    }
  }
}
