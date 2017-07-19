package mx.gox.infonavit.sicj.admin

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='name')
@ToString(includes='name', includeNames=true, includePackage=false)
class Perfil implements Serializable {

	private static final long serialVersionUID = 1

	String name

	Perfil(String name) {
		this()
		this.name = name
	}

	Set<Rol> getAuthorities() {
		PerfilRol.findAllByPerfil(this)*.rol
	}

	static constraints = {
		name blank: false, unique: true
	}

	static mapping = {
		cache true
	}
}
