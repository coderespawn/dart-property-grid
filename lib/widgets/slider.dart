part of property_grid;

typedef void SliderValueChangeEvent(Slider sender, int value);

class Slider {
  DivElement element;
  DivElement _elementHandle;
  DivElement _elementBody;
  
  int _value = 50;
  int _min = 0;
  int _max = 100;
  
  int get value => _value;
  set value(int v) { _value = v; _rebuildLayout(); }
  
  int get min => _min;
  set min(int v) { _min = v; _rebuildLayout(); }
  
  int get max => _max;
  set max(int v) { _max = v; _rebuildLayout(); }
  
  SliderValueChangeEvent onValueChanged;
  
  StreamSubscription<MouseEvent> streamMouseUp;
  StreamSubscription<MouseEvent> streamMouseMove;
  
  Slider() {
    element = new DivElement();
    element.classes.add("property-widget-slider-base");
    
    _elementHandle = new DivElement();
    _elementHandle.classes.add("property-widget-slider-handle");
    element.nodes.add(_elementHandle);
    
    _elementBody = new DivElement();
    _elementBody.classes.add("property-widget-slider-body");
    element.nodes.add(_elementBody);
    
    _rebuildLayout();
    
    element.onMouseDown.listen(_startDragging);
  }
  
  void _startDragging(MouseEvent e) {
    _handleDrag(e);
    _stopListeners();
    
    streamMouseUp = document.body.onMouseUp.listen(_stopDragging);
    streamMouseMove = document.body.onMouseMove.listen(_handleDrag);
  }
  
  void _stopDragging(MouseEvent e) {
    _stopListeners();
  }
  
  void _handleDrag(MouseEvent e) {
    final rect = element.getBoundingClientRect();
    final scrollLeft = _getScrollLeft(element);
    final scrollTop = _getScrollTop(element);
    final containerLeft = rect.left + scrollLeft;
    final containerTop = rect.left + scrollTop;
    var containerWidth = rect.width;
    var x = e.pageX - containerLeft;
    var y = e.pageY - containerTop;
    if (x < 0) x = 0;
    if (x > containerWidth) x = containerWidth;
    
    if (containerWidth <= 0) containerWidth = 1;
    final ratio = x / containerWidth;
    value = (min + (max - min) * ratio).toInt();
    if (onValueChanged != null) {
      onValueChanged(this, value);
    }
    _rebuildLayout();
  }
  
  void _rebuildLayout() {
    final handleWidth = _elementHandle.clientWidth;
    final handleHeight = _elementHandle.clientHeight;
    
    final containerWidth = element.clientWidth;
    final containerHeight = element.clientHeight;

    final y = (containerHeight - handleHeight) ~/ 2;
    num denominator = (max - min);
    if (denominator == 0) denominator = 1;
    final ratio = (value - min) / denominator;
    final x = (containerWidth * ratio).toInt() - handleWidth ~/ 2;
    
    _elementHandle.style.left = "${x}px";
    _elementHandle.style.top = "${y}px";
  }
  
  
  void _stopListeners() {
    if (streamMouseUp != null) {
      streamMouseUp.cancel();
      streamMouseUp = null;
    }
    if (streamMouseMove != null) {
      streamMouseMove.cancel();
      streamMouseMove = null;
    }
  }
  
  int _getScrollLeft(Element element) {
    if (element == null) return 0;
    return element.scrollLeft + _getScrollLeft(element.parent);
  }

  int _getScrollTop(Element element) {
    if (element == null) return 0;
    return element.scrollTop + _getScrollTop(element.parent);
  }
}

