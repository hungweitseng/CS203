/* -*- C++ -*- */

#ifndef _SCOPED_ARRAY
#define _SCOPED_ARRAY

#include <cstddef>

// scoped_array extends auto_ptr to arrays. Deletion of the array
// pointed to is guaranteed, either on destruction of the scoped_array
// or via an explicit reset().  This implementation is based on the
// boost scoped_array class. 

template <typename T> 
class scoped_array 
{
public:
  typedef T value_type;

  // Stash the array pointer away for later use.

  explicit scoped_array (T *p = 0) : ptr_ (p) // never throws
  {
  }

  // Delete the array pointer.

  ~scoped_array () // never throws
  {
    delete [] this->ptr_;
  }

  // Releases ownership of the underlying pointer. Returns that pointer.

  T *release (void) 
  {
    T *old = this->ptr_;
    this->ptr_ = 0;
    return old;
  }

  // Requires that p points to an object of class T or a class derived
  // from T for which delete p is defined and accessible, or p is a
  // null pointer. Deletes the current underlying pointer, then resets
  // it to p.

  void reset (T *p = 0) // never throws
  {
    this_type (p).swap (*this);
  }

  // Return the subscript into the array.

  T &operator[](size_t i) const // never throws
  {
    return this->ptr_[i];
  }

  // Return the underlying pointer to the array.

  T *get() const // never throws
  {
    return this->ptr_;
  }

  // Implicit conversion to "bool"
  bool operator! () const // never throws
  {
    return this->ptr_ == 0;
  }

  // Swap the contents of this scoped array with <b>.

  void swap (scoped_array<T> &b) // never throws
  {
    T *tmp = b.ptr_;
    b.ptr_ = this->ptr_;
    this->ptr_ = tmp;
  }

  // Swap the contents of pointer <b> with <ptr_>.

  void swap (T *&b) // never throws
  {
    T *tmp = b;
    b = this->ptr_;
    this->ptr_ = tmp;
  }

private:
  T *ptr_;

  // Disallow copying
  scoped_array (const scoped_array<T> &);
  scoped_array &operator=(const scoped_array<T> &);

  typedef scoped_array<T> this_type;
};

#endif /* _SCOPED_ARRAY_H */
