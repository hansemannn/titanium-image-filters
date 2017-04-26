var GPUImage = require('ti.imagefilters');
var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});
var btn = Ti.UI.createButton({
    title: 'Apply Sepia Filter',
    top: 50
});
var imageName = 'test.jpg'
var img = Ti.UI.createImageView({
    image: imageName
});
win.add(img);
btn.addEventListener('click', function() {
    var image = GPUImage.filteredImage({
        image: imageName,
        filter: GPUImage.FILTER_SEPIA, // or the filter class name, e.g. `GPUImageHueFilter`
        callback: function(e) {
            img.setImage(e.image);
        }
    });
});
win.add(btn);
win.open();
