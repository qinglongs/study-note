const wm = new WeakMap();

class User {
  constructor(id) {
    this.idProperty = Symbol('id');
    this.setId(id);
  }

  setPrivate(property, value) {
    const privateMember = wm.get(this) || {};
    privateMember[property] = value;
    wm.set(this, privateMember);
  }

  getPrivate(property) {
    return wm.get(this)[property]
  }

  setId(id) {
    this.setPrivate(this.idProperty, id);
  }

  getId() {
    return this.getPrivate(this.idProperty)
  }
}

