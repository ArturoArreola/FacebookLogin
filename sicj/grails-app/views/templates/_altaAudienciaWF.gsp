<div class="col-lg-12">
    <g:if test="${juicio.estadoDeJuicio.id != 4 && juicio.estadoDeJuicio.id != 6 && juicio.estadoDeJuicio.id != 7}">
        <g:form class="form-horizontal" id="modalAudienciaWFForm" name="modalAudienciaWFForm">
            <input type="hidden" name="juicioAudienciaId" id="juicioAudienciaId" value="${juicio.id}"/>
            <div class="row">
                <div class="col-md-12" id="mensajesAudiencia">
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group" id="data_1">
                        <label>Fecha de Audiencia *</label>
                        <div id="divFechaAudiencia" class="input-group date datepicker">
                            <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly name="fechaAudiencia" id="fechaAudiencia" type="text" class="form-control" value="">
                        </div>
                    </div>  
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group" id="data_1">
                        <label>Hora de Audiencia *</label>
                        <div class="input-group clockpicker">
                            <span class="input-group-addon">
                                <span class="fa fa-clock-o"></span>
                            </span>
                            <input type="text" style="width: 255px;text-align: center;"  class="form-control" value="09:30" name="horaAudiencia" id="horaAudiencia" readOnly>
                        </div>
                    </div>  
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label>Tipo de Audiencia *</label>
                        <div class="input-group">
                            <g:select noSelection="['':'Elija el Tipo de Audiencia...']" required data-placeholder="Elija el Tipo de Audiencia..." class="chosen-select" style="width:300px;" tabindex="2" name="tipoDeAudiencia.id" id="tipoDeAudiencia" from="${mx.gox.infonavit.sicj.catalogos.TipoDeAudiencia.findAllByMateria(juicio?.materia,[sort: 'nombre'])}" optionKey="id" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <label>Asistente *</label>
                        <div class="input-group">
                            <input id="nombreAsistente" name="nombreAsistente" maxlength="80" required style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();">
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <<g:submitToRemote onSuccess="mostrarAudienciaWF(data);" onFailure="alert('algo fallo');" onComplete="" class="btn btn-primary" url="[controller: 'audienciaJuicio',action: 'save']" method="POST" value="Guardar"/>
                        <!--<button type="submit" class="btn btn-primary">Guardar</button>-->
                    </div>
                </div>
            </div>
        </g:form>
    </g:if>
    <g:else>
        <center>
            <div class="alert alert-danger">
                El juicio se encuentra en estado ${juicio.estadoDeJuicio}, no es posible agregar audiencias.
            </div>
        </center>
    </g:else>
</div>