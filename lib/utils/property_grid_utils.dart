part of property_grid;

/** Gets the left offset of the element relative to the page */
int _getElementPageLeft(Element element) {
  return _getRecursiveOffset(element, (e) => e.offsetLeft);
}

/** Gets the top offset of the element relative to the page */
int _getElementPageTop(Element element) {
  return _getRecursiveOffset(element, (e) => e.offsetTop);
}

typedef int ElementOffsetGetter(Element element);
/** 
 * Recursively traverses to all the parents and gather's their offsets
 * This is used by other functions to find Left and Top offsets relative 
 * to the page
 */
int _getRecursiveOffset(Element element, ElementOffsetGetter getOffset) {
  if (element == null) return 0;
  return getOffset(element) + _getRecursiveOffset(element.offsetParent, getOffset);
}