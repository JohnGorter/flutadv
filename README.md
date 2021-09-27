# polymer

## Using elements

### Day 1

1. Intro to Polymer
    1. Explain Web components specifications
    1. Explain Polymer project setup
1. Using elements - basics (0,5 day)
    1. Mediator pattern
    1. `[[]]` vs `{{}}`
    1. Intro to "property effects"
    1. dom-repeat and dom-if
    1. Firing events
    1. Lab: create todo app (which lab?)
    1. Advanced scenario with `array-selector`
    1. Filtering and sorting lists
    1. Lab: todo app ~ create done flag
    1. Explain `this.set`, `this.notifyPath`, `this.push`, etc
1. Layouts (~1h)
    1. Install iron-elements (don't show element catalog yet)
    1. Use style `<style include="iron-flex iron-flex-alignment"></style>`
    1. Create header, flex content, footer with container 100%
    1. Lab: create layout for todo app
1. Use interface elements (back to using elements) (till end of day)
    1. Pro tip: Faker.js
    1. Introduce polymer elements catalog
    1. Demo `iron-pages`, `iron-list` (with grid view), `iron-icon-set`, `iron-icon`, `iron-image`,
    1. `paper-toolbar`, `paper-header-panel`, `paper-drawer-panel`, `paper-button`, `paper-icon-button`
    1. `paper-menu` with mediator pattern (selected prop in menu and iron-pages ~ no code routing)
    1. Lab: use the elements in the todo-app

### Day 2

1. Animations (1h ~ 1h15)
    1. Go to catalog and show neon-elements
    1. Copy paste examples from slides
    1. Show demo's (ball animations)
    1. Lab: animate todo-app
1. Forms (~till noon)
    1. Build-in validations (read docs of iron-input, paper-input wraps iron-input)
    1. Custom validations
    1. Demo the custom validation example
1. Routing + lazy loading (~1h)
    1. Go to catalog and show app-elements
    1. Demo app-location and app-routes
        1. Including child routes (provide tail of parent route to child route)
    1. Lazy loading with `this.resolveUrl('./my-element.html')`
    1. Lazy loaded router
    1. Route the todo-app
1. Offline apps (~2h)
    1. Plain html javascript network detection (`navigator.onLine`)
    1. Network status behavior (on-offline support)
    1. Service workers in plain javascript
    1. Introduce platinum elements (cool html5 features like bluetooth, push notifications, service workers etc)
    1. `platinum-sw`, includes work with slightly different syntax
1. Choose: storage / testing / localization
1. Tooling