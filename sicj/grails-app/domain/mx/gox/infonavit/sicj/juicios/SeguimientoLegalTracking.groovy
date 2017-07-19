package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Delegacion
import mx.gox.infonavit.sicj.catalogos.Materia

class SeguimientoLegalTracking implements Serializable{
    
    Juicio juicio
    String idAsunto
    Materia naturaleza
    Delegacion delegacion
    String expInterno
    String expJuicio
    String tipoJuicio
    String cofaNombre
    String coflTitulo
    String respuesta
    String usuarioAlta
    Date fechaAlta
    String usuarioCambio
    Date fechaCambio
    
    static constraints = {
        juicio (nullable: false)
        idAsunto (nullable: false)
        naturaleza (nullable: false)
        delegacion (nullable: false)
        expInterno (nullable: true)
        expJuicio (nullable: true)
        tipoJuicio (nullable: true)
        cofaNombre (nullable: true)
        coflTitulo (nullable: true)
        respuesta (nullable: true)
        usuarioAlta (nullable: true)
        fechaAlta (nullable: true)
        usuarioCambio (nullable: true)
        fechaCambio (nullable: true)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_seguimiento_legal_tracking', params:[sequence:'seguimiento_legal_tracking_id_seq']
    }
}
