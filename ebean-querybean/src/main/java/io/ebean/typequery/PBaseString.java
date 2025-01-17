package io.ebean.typequery;

/**
 * Base for property types that store as String Varchar types.
 *
 * @param <R> the root query bean type
 */
public abstract class PBaseString<R,T> extends PBaseCompareable<R, String> {

  /**
   * Construct with a property name and root instance.
   *
   * @param name property name
   * @param root the root query bean instance
   */
  PBaseString(String name, R root) {
    super(name, root);
  }

  /**
   * Construct with additional path prefix.
   */
  PBaseString(String name, R root, String prefix) {
    super(name, root, prefix);
  }

  /**
   * Is equal to. The same as <code>eq</code> but uses the strong type as argument rather than String.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R equalToType(T value) {
    expr().eq(_name, value);
    return _root;
  }

  /**
   * Is not equal to. The same as <code>ne</code> but uses the strong type as argument rather than String.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R notEqualToType(T value) {
    expr().ne(_name, value);
    return _root;
  }

  //  common string / expressions ------------

  /**
   * Case insensitive is equal to.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R ieq(String value) {
    expr().ieq(_name, value);
    return _root;
  }

  /**
   * Case insensitive is equal to.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R iequalTo(String value) {
    expr().ieq(_name, value);
    return _root;
  }

  /**
   * Like - include '%' and '_' placeholders as necessary.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R like(String value) {
    expr().like(_name, value);
    return _root;
  }

  /**
   * Starts with - uses a like with '%' wildcard added to the end.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R startsWith(String value) {
    expr().startsWith(_name, value);
    return _root;
  }

  /**
   * Ends with - uses a like with '%' wildcard added to the beginning.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R endsWith(String value) {
    expr().endsWith(_name, value);
    return _root;
  }

  /**
   * Contains - uses a like with '%' wildcard added to the beginning and end.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R contains(String value) {
    expr().contains(_name, value);
    return _root;
  }

  /**
   * Case insensitive like.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R ilike(String value) {
    expr().ilike(_name, value);
    return _root;
  }

  /**
   * Case insensitive starts with.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R istartsWith(String value) {
    expr().istartsWith(_name, value);
    return _root;
  }

  /**
   * Case insensitive ends with.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R iendsWith(String value) {
    expr().iendsWith(_name, value);
    return _root;
  }

  /**
   * Case insensitive contains.
   *
   * @param value the equal to bind value
   * @return the root query bean instance
   */
  public final R icontains(String value) {
    expr().icontains(_name, value);
    return _root;
  }

  /**
   * Add a full text "Match" expression.
   * <p>
   * This means the query will automatically execute against the document store (ElasticSearch).
   * </p>
   *
   * @param value the match expression
   */
  public final R match(String value) {
    expr().match(_name, value);
    return _root;
  }
}
