test_task_evencir — App Overview

Screens
1) Splash
- simple splash screen.

2) Main Shell (Bottom Navigation)
- navigation bar holding states of all four pages in it.

3) Nutrition
-first page containing weekly calendar then wokrouts along with icon changing pr time of device.
and simple cards in the ui.

4) Plan
-used LongPressDraggable and DragTarget to move/swap workouts, with ChangeNotifier.
-2-week plan calendar with  AppBar, weekly sections, and  workout cards.

5) Mood
- ring selection updates the mood label using switch.
- circular ring selector in the center updates mood by drag angle, mapped live through ChangeNotifier into states like Calm, Content, and Happy.
- top gradient uses a DecoratedBox with a RadialGradient fading into transparency at the top stacked.
6) Profile
- Simple  page included as the 4th tab.

Dependencies Used
- provider
  Used for state management via ChangeNotifier (bottom tab index, mood selection, nutrition insights, and plan calendar).
- flutter_screenutil
  Used for responsive sizing to match UI specifications across different device sizes.
- flutter_svg
  Used for SVG icons in bottom navigation and other UI assets.
- cupertino_icons
  Standard iOS-style icon pack (default Flutter dependency).

Project Structure
The app is organized to keep UI, state, and domain concepts separated.

lib/core
Shared app-level utilities such as:
- Colors
- Font family
- Date helpers
- Common utility functions

lib/domain
Contains business/domain-level concepts such as:
- Mood enums
- Shared logic
- Future business logic / API integration logic

lib/presentation
Main presentation layer containing:
- Screens
- Widgets
- State-related UI handling

lib/presentation/pages
Contains all four main screens:
- NutritionPage
  Dashboard layout with calendar header, workout card, and insights section (hydration gauge + summary cards).
- PlanPage
  Training calendar with two weeks and drag-and-drop interaction between training day cards.
- MoodPage
  Ring-based mood selector that maps the selected angle to a mood label, with Continue action and SnackBar confirmation.
- ProfilePage
  Simple extra screen.

lib/presentation/shell
Contains the main shell and bottom navigation bar.

lib/presentation/providers
ChangeNotifier classes used by the UI:
- BottomNavNotifier
  Holds the selected bottom tab index.
- MoodSelectionNotifier
  Holds ring angle state and determines the current mood based on the selected ring position.
- NutritionInsightsNotifier
  Holds selected day data and computed values/strings shown on the Nutrition page.
- PlanCalendarNotifier
  Holds calendar state and supports drag-and-drop swap behavior.

lib/presentation/widgets
Contains reusable/custom widgets used across screens.

lib/presentation/painters
Contains custom painters, such as:
- Hydration gauge painter used in the hydration card.

lib/presentation/splash
- SplashPage



