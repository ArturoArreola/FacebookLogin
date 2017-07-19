package mx.gox.infonavit.sicj.admin

import groovy.transform.EqualsAndHashCode
import groovy.transform.ToString

@EqualsAndHashCode(includes='username')
@ToString(includes='username', includeNames=true, includePackage=false)
class Usuario implements Serializable {

    private static final long serialVersionUID = 1

    transient springSecurityService

    String username
    String password
    boolean enabled = true
    boolean accountExpired = false
    boolean accountLocked = false
    boolean passwordExpired = false
    String nombre
    String apellidoPaterno
    String apellidoMaterno
    String email
    String tipoDeUsuario
    Despacho despacho
    Delegacion delegacion
    Proveedor proveedor
    Date fechaDeRegistro = new Date()
    Date fechaDeBloqueo
    boolean responsableDelDespacho = false
    boolean gerenteJuridico = false
    boolean proveedorResponsable = false
    String rutaCartaResponsiva
    

    static belongsTo = [Despacho,Delegacion]    
    
    Usuario(String username, String password) {
        this()
        this.username = username
        this.password = password
    }

    Set<Perfil> getAuthorities() {
        UsuarioPerfil.findAllByUsuario(this)*.perfil
    }
    
    Set<Rol> getRoles() {
        UsuarioRol.findAllByUsuario(this)*.rol
    }

    def beforeInsert() {
        encodePassword()
    }

    def beforeUpdate() {
        if (isDirty('password')) {
            encodePassword()
        }
    }

    protected void encodePassword() {
        password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
    }

    static transients = ['springSecurityService']

    static constraints = {
        username blank: false, unique: true
        password blank: false
        rutaCartaResponsiva nullable: true
        fechaDeBloqueo nullable: true
        tipoDeUsuario blank: false, inList: ['INTERNO','EXTERNO','PROVEEDOR']
        despacho nullable: true
        proveedor nullable: true
    }

    static mapping = {
        password column: '`password`'
    }
    
    String toString () {
        "${username} - ${nombre} ${apellidoPaterno} ${apellidoMaterno}"
    }
}
