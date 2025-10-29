class Story {
  final String id;
  final String userName;
  final String userImage;
  final bool isLive;
  final bool hasStory;
  final bool isAddStory;

  Story({
    required this.id,
    required this.userName,
    required this.userImage,
    this.isLive = false,
    this.hasStory = true,
    this.isAddStory = false,
  });
}
