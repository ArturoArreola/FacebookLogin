package mx.gox.infonavit.sicj.admin

class Division implements Serializable{

    String nombre
    String descripcion
    long valorMinimo
    long valorMaximo
    
    static constraints = {
        nombre(blank:false)
        descripcion(blank:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_division', params:[sequence:'division_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
