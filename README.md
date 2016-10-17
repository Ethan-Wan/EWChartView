## Xcode code Coverage

#### 一. 勾选测试选项

首先新建一个项目，并确认你选上了Unit tests选项

![](http://coding.hengtiansoft.com/mobilecoe/ios-standardization-doc/raw/master/images/CodeCoverage/UnitTests.png)

#### 二. 勾选code coverage

将code coverage勾选，写代码时，默认是关闭的。所以你需要编辑一下你的测试 scheme，把它打开。

![](http://coding.hengtiansoft.com/mobilecoe/ios-standardization-doc/raw/master/images/CodeCoverage/TestCodeCoverage.png)

#### 三. 编写测试用例，运行并查看覆盖率

command+u 运行测试，并查看覆盖率

![](http://coding.hengtiansoft.com/mobilecoe/ios-standardization-doc/raw/master/images/CodeCoverage/CoverageResult.png)

运行结束后打开Xcode左边窗口的Report Navigator面板，选中你刚运行的测试。然后在tab中选中 Coverage。
将鼠标停在某个类上就能看到覆盖率的百分比，双击某个类，你就能进去查看哪些代码被执行了，哪些没有。这样就可以完善
你的测试用例了。
