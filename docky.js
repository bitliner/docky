/* jshint node:true */
'use strict';

var YamlParser = require('yamljs'),
	ejs = require('ejs');

// YamlParser.parse(require('fs').readFileSync(require('path').resolve(__dirname, './production.yml')));
var containerName2conf = YamlParser.load(require('path').resolve(__dirname, './production.yml'));
var template = require('fs').readFileSync(require('path').resolve(__dirname, './template-script.sh.ejs'), {
	encoding: 'utf8'
});


var images = [];
Object.keys(containerName2conf).forEach(function(containerName) {
	var image, containerConfiguration;

	containerConfiguration = containerName2conf[containerName];

	image = {
		containerName: containerName,
		name: containerConfiguration.image,
		ports: containerConfiguration.ports || [],
		environment: containerConfiguration.environment || []
	};

	images.push(image);

});

var output;
output = ejs.render(template, {
	images: images
});
console.log(output);
require('fs').writeFileSync(require('path').resolve(__dirname, './script.sh'), output, {
	encoding: 'utf8'
});
// console.log(template);
// console.log(images);