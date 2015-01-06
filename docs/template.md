#JSON template
A JSON template describes the view of a page or a module which will be rendered as HTML node.

A node consists of the following *fields*

* type
> The type of the node like a `DIV` or a custom element
* attributes
> All attributes of the node
* children
> Each node can contain a various number of children nodes

The following JSON template...

```json
{
  "type": "StackPanel",
  "attributes": [{
    "name": "orientation",
    "value": "vertical"
  }],
  "children": [{
    "type": "Fragment",
    "attributes": [{
      "name": "name",
      "value": "TabBar"
    },{
      "name": "orientation",
      "value": "horizontal"
    }],
    "children": []
  }, {
    "type": "Fragment",
    "attributes": [{
      "name": "name",
      "value": "Content"
    },{
      "name": "orientation",
      "value": "horizontal"
    }],
    "children": []
  }]
}
```

... will be rendered as

```html
<StackPanel orientation="vertical">
    <Fragment name="TabBar" orientation="horizontal"></Fragment>
    <Fragment name="Content" orientation="horizontal"></Fragment>
</StackPanel>
```

#Event- \& Data-Bindings
A property binding can be defined by using the `bindings` field which is an array of key value pairs. The key represents the attribute to update and the value is the name of the property with a leading `#`.

```json
"bindings": [{
  "attribute": "title",
  "property": "title"
}]
```

An event binding is defined by using the `events` field which is also an array of key value pairs. In this case the key is the event name like `click`, etc. without the `on`. The value points to a callback function and can contain a parameter list.

```json
"events": [{
  "type": "click",
  "binding": "openPage(index:#index=1,element:#el)"
}]
```

A parameter consists of a name `index:`, the name of a property to bind `#index` and a default value `=1`. Each parameter is separated by an `,`.


###Example
```json
{
  "type": "StackPanel",
  "attributes": [{
    "name": "orientation",
    "value": "vertical"
  }],
  "children": [{
    "type": "Button",
    "bindings": [{
      "attribute": "title",
      "property": "title"
    }],
    "events": [{
      "type": "click",
      "binding": {
        "callback": "openPage",
        "parameter": [{
          "name": "uri",
          "value": "home_uri"
        }]
      }
    }],
    "attributes": [{
      "name": "title",
      "value": "Click Me!"
    }],
    "children": []
  }]
}
```
