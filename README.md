# Godot Tween Library Plugin

Simple plugin provided a static class with some useful tween animations.

Not intended to be a one-size-fits-all-for-every-one-and-everything plugin, but rather a very 
simple library to address my feeling when doing my first game jam the I needed more reusable 
library functions for silly repetive things like basic fade tweens etc

Only just began this but will expand it as I go, so as always don't expect too much yet!

## Usage

No autoload, just a simple static class, access methods directly by class name.

```gdscript
var thing: Sprite2D = $sprite_2d    # for example, any CanvasItem should work

....

TweenHelper.fadeout( thing )		# fade out and go invisible	
``` 
