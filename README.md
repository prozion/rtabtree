# Tabtree

Tabtree &mdash; is a compact format to write RDF triples. It uses some syntactic sugar to make a work of editing ontologies in the code editor as easy as possible.

## Tabs define a level of hierarchy

**Tabtree source**
```tabtree
Africa
  Kenya
    Elgeyo-Marakwet
      Iten
Europe
  Germany
    Saxony_Land
      Dresden
  Russia
    City_of_Moscow
      Belyaevo
      Zelenograd
    Rostov_region
      Taganrog
        Bogudonia
```

## Files includes

Big ontologies and knowledge graphs is good to divide into several files, regarding the regions of internal cohesion. And then combine them into one resulting Turtle file, ready for uploading to appropriate semtech application.

Here is an example of pasting contents of `factories.tree` into 'central' file called `main.tree`

**Tabtree source**
```tabtree
; main.tree

[factories.tree]
```

## Reification

For writing statements like:

*'By March, 2020, the factory produced 2.5% fat strawberry-flavoured yogurt'*

**Tabtree source**
```tabtree
Milk_factory product:Yogurt_strawberry^fat:2.5^date:2020-03
```

**Turtle result**
```turtle
Stmt_506_product_Yogurt_strawberry
  rdf:type rdf:Statement ;
  rdf:subject :Milk_factory ;
  rdf:predicate :product ;
  rdf:object :Yogurt_strawberry ;
  :fat "2.5"^^xsd:decimal ;
  :date "2020-03"^^xsd:date .
```

## Expanding

**+** sign propagates the predicate-object pair among all the children of the node, where this form was written:

**Tabtree source**
```tabtree
cities +a:UrbanPlace
  Beijing
  Shanghaj
  Shenzhen
    Futian_district
```

**Turtle result**
```turtle
:Beijing rdf:type :UrbanPlace .
:Shanghaj rdf:type :UrbanPlace .
:Shenzhen rdf:type :UrbanPlace .
:Futian_district rdf:type :UrbanPlace .
```

**++** Double-plus sign includes predicate-object to the node of origin:

**Tabtree source**
```tabtree
  Moscow ++a:UrbanPlace
    Zelenograd
      Noviy_Gorod
        Microdistrict_14
```

**Turtle result**
```turtle
:Moscow rdf:type :UrbanPlace .
:Zelenograd rdf:type :UrbanPlace .
:Noviy_Gorod rdf:type :UrbanPlace .
:Microdistrict_14 rdf:type :UrbanPlace .
```

<b>*</b> Asterisk sign overwrites predicate-object inherited from above, while plain predicate-object without prefixes just adds up to the inherited one:

**Tabtree source**
```tabtree
  Moscow ++a:UrbanPlace
    Zelenograd
      Stariy_Gorod a:InformallyNamedArea
        Matushkino-Savelki *a:AdministrativeUnit
      Noviy_Gorod
        Microdistrict_14
```

**Turtle result**
```turtle
:Moscow rdf:type :UrbanPlace .
:Zelenograd rdf:type :UrbanPlace .
:Stariy_Gorod rdf:type :UrbanPlace, :InformallyNamedArea .
:Matushkino-Savelki rdf:type :AdministrativeUnit .
:Noviy_Gorod rdf:type :UrbanPlace .
:Microdistrict_14 rdf:type :UrbanPlace .
```


## Built-ins

**Tabtree source**
```
  City subclass-of:UrbanPlace
```

**Turtle result**
```
  :City rdfs:subClassOf :UrbanPlace .
```
