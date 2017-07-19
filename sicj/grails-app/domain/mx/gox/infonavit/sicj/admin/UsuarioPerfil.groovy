package mx.gox.infonavit.sicj.admin

import grails.gorm.DetachedCriteria
import groovy.transform.ToString
import org.apache.logging.log4j.Logger
import org.apache.logging.log4j.LogManager
import org.apache.logging.log4j.ThreadContext
import org.apache.commons.lang.builder.HashCodeBuilder

@ToString(cache=true, includeNames=true, includePackage=false)
class UsuarioPerfil implements Serializable {

    private static final Logger log = LogManager.getLogger(UsuarioPerfil)
    
	private static final long serialVersionUID = 1

	Usuario usuario
	Perfil perfil

	UsuarioPerfil(Usuario u, Perfil rg) {
		this()
		usuario = u
		perfil = rg
	}

	@Override
	boolean equals(other) {
		if (!(other instanceof UsuarioPerfil)) {
			return false
		}

		other.usuario?.id == usuario?.id && other.perfil?.id == perfil?.id
	}

	@Override
	int hashCode() {
		def builder = new HashCodeBuilder()
		if (usuario) builder.append(usuario.id)
		if (perfil) builder.append(perfil.id)
		builder.toHashCode()
	}

	static UsuarioPerfil get(long usuarioId, long perfilId) {
		criteriaFor(usuarioId, perfilId).get()
	}

	static boolean exists(long usuarioId, long perfilId) {
		criteriaFor(usuarioId, perfilId).count()
	}

	private static DetachedCriteria criteriaFor(long usuarioId, long perfilId) {
		UsuarioPerfil.where {
			usuario == Usuario.load(usuarioId) &&
			perfil == Perfil.load(perfilId)
		}
	}

	static UsuarioPerfil create(Usuario usuario, Perfil perfil, boolean flush = false) {
		def instance = new UsuarioPerfil(usuario: usuario, perfil: perfil)
		instance.save(flush: flush, insert: true)
                if(instance.hasErrors()){
                    instance.errors.each{
                        log.info it
                    }
                }
		instance
	}

	static boolean remove(Usuario u, Perfil rg, boolean flush = false) {
		if (u == null || rg == null) return false

		int rowCount = UsuarioPerfil.where { usuario == u && perfil == rg }.deleteAll()

		if (flush) { UsuarioPerfil.withSession { it.flush() } }

		rowCount
	}

	static void removeAll(Usuario u, boolean flush = false) {
		if (u == null) return

		UsuarioPerfil.where { usuario == u }.deleteAll()

		if (flush) { UsuarioPerfil.withSession { it.flush() } }
	}

	static void removeAll(Perfil rg, boolean flush = false) {
		if (rg == null) return

		UsuarioPerfil.where { perfil == rg }.deleteAll()

		if (flush) { UsuarioPerfil.withSession { it.flush() } }
	}

	static constraints = {
		usuario validator: { Usuario u, UsuarioPerfil ug ->
			if (ug.perfil == null || ug.perfil.id == null) return
			boolean existing = false
			UsuarioPerfil.withNewSession {
				existing = UsuarioPerfil.exists(u.id, ug.perfil.id)
			}
			if (existing) {
				return 'userGroup.exists'
			}
		}
	}

	static mapping = {
		id composite: ['perfil', 'usuario']
		version false
	}
}
