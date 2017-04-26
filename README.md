# Titanium Image Filters

Use the GPUImage library to apply pre-built and custom filters to images in Titanium Edit
Add topics.

## Credits

Really all credits of this module should go to [@BradLarson](https://github.com/BradLarson) who made the
amazing [GPUImage](https://github.com/BradLarson/GPUImage) library! There are over [125 built-in filters](https://github.com/BradLarson/GPUImage#built-in-filters)
plus the ability to create own filters via shaders.

## Features

Right now, this module supports applying built-in filters to a still image:
```js
var GPUImage = require('ti.imagefilters');
var imageName = 'test.jpg'

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
    title: 'Apply Brightness Filter',
    top: 50
});

var img = Ti.UI.createImageView({
    image: imageName
});

btn.addEventListener('click', function() {
    var filter = GPUImage.createFilter({
        type: 'GPUImageBrightnessFilter',

        // Properties are optional and automatically
        // mapped to the native properties. Check out
        // the GPUImage documentation for possible values.
        properties: {
            brightness: 0.8
        }
    });
    
    var image = GPUImage.generateFilteredImage({
        image: imageName,
        filter: filter,
        callback: function(e) {
            img.setImage(e.image);
        }
    });
});

win.add(img);
win.add(btn);

win.open();
```
The module also supports all possible filter configurations. They are mapped to the `properties`
attribute that expects an object of possible filter values. For example, the `GPUImageBrightnessFilter`
supports the `brightness` property (see native docs [here](https://github.com/BradLarson/GPUImage#color-adjustments)), so you would include it as seen in
the above example. Simple as that!

## Android

I created an Android module project as well, which does nothing right now, but could use [this library](https://github.com/CyberAgent/android-gpuimage).
Go ahead!
