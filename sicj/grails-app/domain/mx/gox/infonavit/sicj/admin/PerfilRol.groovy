package mx.gox.infonavit.sicj.admin

import grails.gorm.DetachedCriteria
import groovy.transform.ToString

import org.apache.commons.lang.builder.HashCodeBuilder

@ToString(cache=true, includeNames=true, includePackage=false)
class PerfilRol implements Serializable {

	private static final long serialVersionUID = 1

	Perfil perfil
	Rol rol

	PerfilRol(Perfil g, Rol r) {
		this()
		perfil = g
		rol = r
	}

	@Override
	boolean equals(other) {
		if (!(other instanceof PerfilRol)) {
			return false
		}

		other.rol?.id == rol?.id && other.perfil?.id == perfil?.id
	}

	@Override
	int hashCode() {
		def builder = new HashCodeBuilder()
		if (perfil) builder.append(perfil.id)
		if (rol) builder.append(rol.id)
		builder.toHashCode()
	}

	static PerfilRol get(long perfilId, long rolId) {
		criteriaFor(perfilId, rolId).get()
	}

	static boolean exists(long perfilId, long rolId) {
		criteriaFor(perfilId, rolId).count()
	}

	private static DetachedCriteria criteriaFor(long perfilId, long rolId) {
		PerfilRol.where {
			perfil == Perfil.load(perfilId) &&
			rol == Rol.load(rolId)
		}
	}

	static PerfilRol create(Perfil perfil, Rol rol, boolean flush = false) {
		def instance = new PerfilRol(perfil: perfil, rol: rol)
		instance.save(flush: flush, insert: true)
		instance
	}

	static boolean remove(Perfil rg, Rol r, boolean flush = false) {
		if (rg == null || r == null) return false

		int rowCount = PerfilRol.where { perfil == rg && rol == r }.deleteAll()

		if (flush) { PerfilRol.withSession { it.flush() } }

		rowCount
	}

	static void removeAll(Rol r, boolean flush = false) {
		if (r == null) return

		PerfilRol.where { rol == r }.deleteAll()

		if (flush) { PerfilRol.withSession { it.flush() } }
	}

	static void removeAll(Perfil rg, boolean flush = false) {
		if (rg == null) return

		PerfilRol.where { perfil == rg }.deleteAll()

		if (flush) { PerfilRol.withSession { it.flush() } }
	}

	static constraints = {
		rol validator: { Rol r, PerfilRol rg ->
			if (rg.perfil == null || rg.perfil.id == null) return
			boolean existing = false
			PerfilRol.withNewSession {
				existing = PerfilRol.exists(rg.perfil.id, r.id)
			}
			if (existing) {
				return 'roleGroup.exists'
			}
		}
	}

	static mapping = {
		id composite: ['perfil', 'rol']
		version false
	}
}
