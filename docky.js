/* jshint node:true */
'use strict';

var YamlParser = require('yamljs'),
	ejs = require('ejs');

var yamlInputFilepath,
	outputScriptName;

// parse input filename
yamlInputFilepath = process.argv[2];
if (!yamlInputFilepath || yamlInputFilepath === '' || yamlInputFilepath.indexOf('.yml') < 0) {
	console.log('Please specify an input file as parameter!', '...found', yamlInputFilepath);
	return;
}

outputScriptName = yamlInputFilepath.split('.yml')[0] + '.sh';
yamlInputFilepath = require('path').resolve('./', yamlInputFilepath);

// parse yaml file
var containerName2conf = YamlParser.load(yamlInputFilepath);

// read template
var template = require('fs').readFileSync(require('path').resolve(__dirname, './template-script.sh.ejs'), {
	encoding: 'utf8'
});

// transform parsed yaml into known and standard data structure
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

// render template
output = ejs.render(template, {
	images: images
});
// console.log(output);
// write to file
require('fs').writeFileSync(require('path').resolve('./', outputScriptName), output, {
	encoding: 'utf8'
});