## slide_action_widget

Slide to complete an action.

![slide](https://user-images.githubusercontent.com/125212731/219509996-adc603a1-a077-4476-b061-2dc513a9ad09.gif)

## Usage

### Standard
```dart
SlideActionWidget(
  backgroundText: 'Purchasing...',
  foregroundText: 'Slide to purchase',
  onComplete: () {
    print('Purchased');
  },
)
```

### Custom
```dart
SlideActionWidget.custom(
  background: Container(
    color: Colors.red.shade100,
    child: Center(
      child: Text(
        'Deleting...',
        style: TextStyle(
          color: Colors.red.shade900,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  ),
  foreground: Container(
    color: Colors.orangeAccent.shade100,
    child: const Center(child: Text('Slide to delete')),
  ),
  thumb: SlideActionThumb(
    width: 60,
    color: Colors.red.shade300,
    borderRadius: BorderRadius.circular(12),
    icon: const Icon(Icons.delete),
  ),
  onComplete: () {
    print('Deleted');
  },
)
```

https://user-images.githubusercontent.com/125212731/219510163-56833c25-cf9b-4be1-b530-afd9a7c76175.mov
