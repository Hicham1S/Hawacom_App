# Mock Data Documentation

This directory contains all dummy/mock data for the Hawacom Update app.

## Files Overview

### 1. `mock_data.dart`
**Main data source** - Contains the primary mock data for:
- **Stories**: User stories with live badges
- **Categories**: Design categories with icons
- **Projects**: Project gallery items
- **Announcements**: Notification-style announcements
- **AI Banner**: Featured AI section data

**Usage:**
```dart
import 'package:hawacom_update/data/mock_data.dart';

// Get stories
List<Story> stories = MockData.getStories();

// Get categories
List<Category> categories = MockData.getCategories();

// Get projects
List<Project> projects = MockData.getProjects();

// Get announcements
List<Announcement> announcements = MockData.getAnnouncements();

// Get AI banner
Map<String, String> aiBanner = MockData.getAIBanner();
```

### 2. `dummy_users.dart`
**User profiles** - Contains detailed user information:
- User names (Arabic)
- Bios/descriptions
- Follower/following counts
- Verification status
- Saudi cities list

**Usage:**
```dart
import 'package:hawacom_update/data/dummy_users.dart';

// Get all users
List<DummyUser> users = DummyUsers.getUsers();

// Get random Arabic names
List<String> names = DummyUsers.getArabicNames();

// Get Saudi cities
List<String> cities = DummyUsers.getCities();
```

### 3. `project_details.dart`
**Project metadata** - Contains detailed project information:
- Descriptions
- Tags
- Likes, views, comments
- Created dates

**Usage:**
```dart
import 'package:hawacom_update/data/project_details.dart';

// Get project details
List<ProjectDetail> details = ProjectDetails.getProjectDetails();

// Get all available tags
List<String> tags = ProjectDetails.getAllTags();

// Find project detail by ID
ProjectDetail? detail = ProjectDetails.getProjectDetails()
    .firstWhere((d) => d.projectId == '1');
```

## Data Structure

### Story
```dart
Story(
  id: '1',
  userName: 'أمينة الهاجري',
  userImage: 'https://via.placeholder.com/150',
  isLive: true,           // Shows live badge
  hasStory: true,         // Has story content
  isAddStory: false,      // Is "Add Story" button
)
```

### Category
```dart
Category(
  id: '1',
  name: 'تصميم معماري',
  iconPath: 'assets/images/icons/architecture.svg',
)
```

### Project
```dart
Project(
  id: '1',
  title: 'مبنى معماري حديث',
  imageUrl: 'https://images.unsplash.com/...',
  category: 'تصميم معماري',
  author: 'أحمد الشهري',
)
```

### Announcement
```dart
Announcement(
  id: '1',
  title: 'لدينا مشروع تصميم الآن!',
  icon: '🎨',
)
```

## Categories Included

1. **تصميم معماري** (Architectural Design)
2. **سوشال ميديا** (Social Media)
3. **ديكور داخلي** (Interior Design)
4. **تصميم أزياء** (Fashion Design)
5. **هويات** (Branding/Identity)
6. **موشن جرافيك** (Motion Graphics)
7. **تصوير فوتوغرافي** (Photography)
8. **رسم توضيحي** (Illustration)

## Users Included

10 diverse users with Arabic names representing different design disciplines:
- Architects
- Graphic Designers
- Fashion Designers
- Motion Designers
- Photographers
- And more...

## Projects Included

10 sample projects across all categories with:
- High-quality Unsplash images
- Realistic Arabic titles
- Category tags
- Author attribution

## Tips for Using Mock Data

1. **Replace images**: Update image URLs when you have real assets
2. **Extend data**: Add more items by following the existing patterns
3. **Localization**: All text is in Arabic (RTL-ready)
4. **Real API**: When ready, replace these static lists with API calls
5. **State Management**: Use with Provider, Riverpod, or Bloc for reactive updates

## Image Placeholders

Currently using:
- **Unsplash**: For project images (free, high-quality)
- **Placeholder.com**: For user avatars (temporary)

**Next step**: Replace with actual assets in `assets/images/` directory

## Adding More Data

To add more items, follow this pattern:

```dart
// In mock_data.dart
static List<Story> getStories() {
  return [
    // Add new story here
    Story(
      id: 'new_id',
      userName: 'New User',
      userImage: 'image_url',
      hasStory: true,
    ),
    // ... existing stories
  ];
}
```

---

**Last Updated**: October 2025
**Version**: 1.0.0
