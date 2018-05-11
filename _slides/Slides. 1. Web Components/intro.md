# Web Components

---
### Web Components

> Encapsulation is one of the pillars on which the Object Oriented Programming paradigm was founded and is normally used to restrict the internal representation of an object from the outside world.

---
### Web Components
Web Components consist of 4 main features from HTML5:

* Custom elements 
    * APIs to define new HTML elements
* Shadow DOM 
    * Encapsulated DOM and styling, with composition
* HTML Imports 
    * Importing HTML documents into other documents
* HTML templates 
    * The template tag, insert chunks of DOM

These features can be used separately or all together

---
### Web Components
You probably already use and know web components syntax
For instance:
    The HTML5 the &lt;video&gt; tag is also a web component

<img src="images/videoelement.png">

---
### Web Components
But the video tag is actually
<img src="images/videoshadowdom.png">

---
### Web Components
Examples of web components
* [Voice Recognition](http://zenorocha.github.io/voice-elements/)
* [Presentation Builder](http://viniciusalmeida.github.io/ninja-presentation/#1)
* [QR Code Generation](http://educastellano.github.io/qr-code/demo/)
* [Gangnam style element](http://html5-demos.appspot.com/gangnam)

---
### Web Components
You can create your own
```html
<slide-show transition="fade">
<slide src="slideone.jpg" thumb="slideone_thumb.jpg" caption="Look at this image">
<slide src="slidetwo.jpg" thumb="slidetwo_thumb.jpg" caption="Look at this other image">
</slide-show>
```

---
### Create your own elements
What makes a web component again?
* Custom elements
* Shadow DOM
* Templates
* HTML Imports

---
### Custom elements
Define the public part of your component

For example

```html
<hello-world></hello-world>
```

---
### Custom elements
To define a new HTML element we need the power of JavaScript!

The <code>customElements</code> global is used for defining
custom element.

Call <code>customElements.define()</code> 
Give class API

---
### Custom elements
An Example
```js
class AppDrawer extends HTMLElement {...}
window.customElements.define('app-drawer', AppDrawer);
```
Usage
```
<app-drawer></app-drawer>
```

---
### Custom elements
Use the class to create a public JavaScript API for your tag.

Extending the example
```js
class AppDrawer extends HTMLElement {
  get open() { return this.hasAttribute('open'); }
  set open(val) { 
    if (val) { this.setAttribute('open', '');} 
    else { this.removeAttribute('open'); } this.toggleDrawer();
  }
  constructor() { super(); this.addEventListener('click', e => { this.toggleDrawer();}); } 
  toggleDrawer() { ... }
} 
customElements.define('app-drawer', AppDrawer);
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 1. Custom Elements

---
### Shadow DOM
> Take all code that doesn't need to be seen during markup 
> placement and obscure it in Shadow DOM

* Each instance is self-contained 
* Styling and scripts inside won't affect the rest of the page. 
* CSS and JavaScript elsewhere won't affect your web component
    * Except for style hooks to allow external CSS targeting
    
---
### Shadow DOM
How to use

```html
<div id="host"></div>
<script>
  var shadow = document.querySelector('#host').createShadowRoot();
  shadow.innerHTML = '<span>Host node</span>';
</script>
```

---
### Shadow DOM
Through all this, we gain the encapsulation of
* Styles
* DOM Elements
* Scripts

---
### Shadow Host & Shadow Root

* Shadow Host
    * DOM element hosting the Shadow DOM subtree
* Shadow Root
    * root of the DOM subtree containing the shadow DOM nodes
    * creates the boundary between normal DOM nodes and Shadow DOM nodes
* Shadow DOM
    * allows for multiple DOM subtrees to be composed into one larger tree
    * next slide shows concept 
* Shadow Boundary
    * The separation between normal DOM world and Shadow DOM world
    * Scripts from either side cannot cross the boundary

---
### Shadow Host & Shadow Root

<img src="images/sd_composition1.png">

---
### Shadow Host & Shadow Root

<img src="images/sd_composition2.png">


---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 2. Shadow DOM

---
### Templates 

> template (n) - A document or file having a preset format, used as a starting 
> point for a particular application so that the format does not have to be recreated each time it is used.

So we can declare a piece of HTML/Script/Style inside of a tempate for later 
or repetetive use

---
### Templates 

To use a template we use the template tag
```html
<template id="mytemplate">
  .... html/script ...
</template>
```

---
### Templates 

A few important characteristics of Templates
* Its content is effectively inert until activated

Your markup is hidden DOM and does not render.

---
### Templates 

* Any content within a template won't have side effects. 

Script doesn't run, images don't load, audio doesn't play,
...until the template is used.

---
### Templates 

* Content is considered not to be in the document. 

Using document.getElementById() or querySelector() in the main 
page won't return child nodes of a template.

---
### Templates 

* Templates can be placed anywhere inside of `head`, `body`, or `frameset` 
and can contain any type of content which is allowed in those elements. 

It can also be placed as a child of `table` or `select`

```html
<table>
<tr>
  <template id="cells-to-repeat">
    <td>some content</td>
  </template>
</tr>
```

---
### Templates 

To use a template, you need to activate it. Otherwise its content will never render. 
The simplest way to do this is by creating a deep copy of its 
.content using `document.importNode()`.

The `.content` property is a read-only DocumentFragment containing the 
guts of the template.

---
### Templates 
```
var t = document.querySelector('#mytemplate');
// Populate the src at runtime.
t.content.querySelector('img').src = 'logo.png';

var clone = document.importNode(t.content, true);
document.body.appendChild(clone);
```
After stamping out a template, its content "goes live". 
In this particular example, the content is cloned, 
the image request is made, and the final markup is rendered.

---
### Example 
Here is a full example
```html
<button onclick="useIt()">Use me</button>
<div id="container"></div>
<script>
  function useIt() {
    var content = document.querySelector('template').content;
    // Update something in the template DOM.
    var span = content.querySelector('span');
    span.textContent = parseInt(span.textContent) + 1;
    document.querySelector('#container').appendChild(
        document.importNode(content, true));
  }
</script>

<template>
  <div>Template used: <span>0</span></div>
  <script>alert('Thanks!')</script>
</template> 
```

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 3. Templates

---
### Template and Shadow DOM
Lets combine the template and the shadow DOM

```html
<template>
<style>...</style>
<div>...</div>
</template>

<div id="host"><p>...</p></div>

<script>
  var shadow = document.querySelector('#host').createShadowRoot();
  shadow.appendChild(document.querySelector('template').content);
</script>
```

---
### HTML Imports

How do we include HTML. Here's your options:
* `iframe` - tried and true but heavyweight. 
An iframe's content lives entirely in a separate context than your page. 
* `AJAX` - Need JS to load HTML? That doesn't seem right.
* `CrazyHacks` - embedded in strings, hidden as comments (e.g. `script type="text/html"`).

 The web's most basic content, HTML, requires the greatest amount of effort to work with

---
### HTML Imports

> A way to include HTML documents in other HTML documents

An Import can also include CSS, JavaScript, or anything else an .html file can contain. 
Ideal for providing libraries and components.
 
---
### How does it work

Include an Import on your page by declaring a `link rel="import"`:

```
<head>
  <link rel="import" href="/path/to/imports/stuff.html">
</head>
```

---
### Feature detection and support

To detect support, check if .import exists on the <link> element
```
function supportsImports() {
  return 'import' in document.createElement('link');
}
if (supportsImports()) {
  // Good to go!
} else {
  // Use other libraries/require systems to load files.
}
```

---
### Load/error events

The `link` element fires a load event when an Import is loaded 
successfully and onerror when the attempt fails (e.g. if the resource 404s).
```
<script>
  function handleLoad(e) {
    console.log('Loaded Import: ' + e.target.href);
  }
  function handleError(e) {
    console.log('Error loading Import: ' + e.target.href);
  }
</script>
<link rel="import" href="file.html"
      onload="handleLoad(event)" onerror="handleError(event)">
```

---
### Using the content

! Including an Import on a page doesn't add the content. 
It means 
> parser, go off an fetch this document so I can use it. 

* The content of an import is called an import document. 
* To access the content of an import, use the link element's .import property:
```
var content = document.querySelector('link[rel="import"]').import;
```

---
### Scripting in Imports

* Imports are not in the main document. You get to maindocument using
`document`.
* A reference to the Import doc is maintained in 'ownerDocument'

---
### Example document reference
```
<link rel="stylesheet" href="http://www.example.com/styles.css">
<link rel="stylesheet" href="http://www.example.com/styles2.css">

<script>
  // importDoc references this import's document
  var importDoc = document.currentScript.ownerDocument;
  // mainDoc references the main document (the page that's importing us)
  var mainDoc = document;
  // Grab the first stylesheet from this import, clone it, append it.
  var styles = importDoc.querySelector('link[rel="stylesheet"]');
  mainDoc.head.appendChild(styles.cloneNode(true));
</script>
```

---
### Dependency management

* Loading JavaScript more than once per page causes errors. 
* HTML Imports can be used to manage dependencies.

By wrapping libraries in an HTML Import, you automatically de-dupe resources. 
* The document is only parsed once. 
* Scripts are only executed once. 

---
### Concatenate imports

* If you have many top-level import links, 
consider combining them into a single resource and importing that file!

* Vulcanize is an npm build tool from the Polymer team that 
recursively flattens a set of HTML Imports into a single file. 

Think of it as a concatenation build step for Web Components.

---
### Async importing
* Imports block rendering of the main page. 
    - This is similar to what ```<link rel="stylesheet">``` does.
* Imports behave similarly because they can contain stylesheets.

To be completely asynchronous and not block the parser or rendering, 
use the async attribute:
```html
<link rel="import" href="/path/to/import_that_takes_5secs.html" async>
```

---
### Importing with scripts
* Imports don't block parsing of the main page. 
* Scripts inside imports are processed in order but don't block the importing page. 
* Scripts on the main document do block parsing.

---
### Import things to remember

* An import's mimetype is `text/html`.
* Resources from other origins need to have CORS enabled.
* Imports from the same URL are retrieved and parsed once. 
* Scripts in an import are processed in order, but do not block the main document parsing.

---
<!-- .slide: data-background="url('images/demo.jpg')" --> 
<!-- .slide: class="lab" -->
## Demo time!
Demo 4. HTML Imports

---
<!-- .slide: data-background="url('images/lab2.jpg')" --> 
<!-- .slide: class="lab" -->
## Lab time!
create a web component