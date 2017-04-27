var GPUImage = require('ti.imagefilters');
var imageName = 'test.jpg'

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var btn = Ti.UI.createButton({
    title: 'Apply Sketch Filter',
    top: 50
});

var img = Ti.UI.createImageView({
    image: imageName
});

btn.addEventListener('click', function() {
    var filter = GPUImage.createFilter({
        type: 'GPUImageSketchFilter'
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
