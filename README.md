# Objective C Enumeration Performance Comparison
This little demo compares the performance and memory footprint of following enumerations
#### For loop
```objc
for (int i = 0; i < [stringValues count]; i++) { ... }
  ```
#### Fast enumeration
```objc
for (NSString *string in stringValues) { ... }
  ```

#### enumerateObjectsUsingBlock
```objc
[stringValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { ... }];
```

#### objectEnumerator
```objc
NSEnumerator *enumerator = [stringValues objectEnumerator];
id obj = nil;
while (obj = [enumerator nextObject]) { ... };
```

#### Concurrent enumerateObjectsUsingBlock
```objc
[stringValues enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) { ... }];
```

#### MakeObjectsPerformSelector
```objc
[stringValues makeObjectsPerformSelector:@selector(uppercaseString)];
```

## Results
On my iPhone 6 I have the following setup for the tests.
* 3 Mio iterations sending the message `uppercaseString`
* Airplane mode
* All apps terminated
* Batterie: 100% and powered by USB

#### Comparison in seconds

| Loop type                  |    Run 1     |    Run 2         |   Run 3                  |
|----------------------------|--------------|------------------|--------------------------|
| For Loop                   | 2.545244     |   2.543291       | 2.545505                 |
| Fast Enumeration           | 2.282996     |   2.279801       | 2.266571                 |
| enumerateObjectsUsingBlock | 2.466647     |   2.440913       |  2.440402                |
| objectEnumerator           | 2.536801     |   2.523067       |  2.508857                |
| Concurrent                 | 1.488604     |   1.505069       |  1.475192                |
| MakeObjectsPerformSelector | 2.951380     |   2.847308       |   2.861406               |


No suprise, the concurrent one wins, because it leverages the two cores of the Apple A8.
But I noticed an even one more interesting side effect : **The Memory footprint** that bas been created after the test.

#### Comparison in memory
| Loop type                  | Peak (MB) | After iteration (MB) |
|----------------------------|-----------|----------------|
| For Loop                   | 28.7       |   3.5         |
| Fast Enumeration           | 28.8       |   3.5         |
| enumerateObjectsUsingBlock | 28.8       |   3.6         |
| objectEnumerator           | 28.8       |   3.3         |
| Concurrent                 | 28.7       |   3.6         |
| MakeObjectsPerformSelector | **291**    |  **278**     |

What is going on in `makeObjectsPerformSelector:`? <br>
Why is the memory footprint increasing so dramatically? <br>
Why stays the memory really high after the iteration has been completed?


## Contact
[Christian Menschel](http://github.com/tapwork) ([@cmenschel](https://twitter.com/cmenschel))

# License
[MIT](LICENSE.md)
