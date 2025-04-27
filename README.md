# Titanium Image Filters

Use the GPUImage library to apply pre-built and custom filters to images in Titanium.

## Credits

Really all credits of this module should go to [@BradLarson](https://github.com/BradLarson) who made the
amazing [GPUImage](https://github.com/BradLarson/GPUImage) library! There are over [125 built-in filters](https://github.com/BradLarson/GPUImage#built-in-filters)
plus the ability to create own filters via shaders.

## Features

Right now, this module supports applying built-in filters to a still image:
```js
import GPUImage from 'ti.imagefilters';

const imageName = 'test.jpg'

const window = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

const btn = Ti.UI.createButton({
    title: 'Apply Brightness Filter',
    top: 50
});

const img = Ti.UI.createImageView({
    image: imageName
});

btn.addEventListener('click', () => {
    const filter = GPUImage.createFilter({
        type: 'GPUImageBrightnessFilter',

        // Properties are optional and automatically
        // mapped to the native properties. Check out
        // the GPUImage documentation for possible values.
        properties: {
            brightness: 0.8
        }
    });
    
    const image = GPUImage.generateFilteredImage({
        image: imageName,
        filter: filter,
        callback: event => {
            img.setImage(event.image);
        }
    });
});

window.add([img, btn]);
window.open();
```

The module also supports all possible filter configurations. They are mapped to the `properties`
attribute that expects an object of possible filter values. For example, the `GPUImageBrightnessFilter`
supports the `brightness` property (see native docs [here](https://github.com/BradLarson/GPUImage#color-adjustments)), so you would include it as seen in
the above example. Simple as that!

## Android

I created an Android module project as well, which does nothing right now, but could use [this library](https://github.com/CyberAgent/android-gpuimage).
Go ahead!
