<g:if test="${audiencia}">
    <div class="col-lg-12">
        <div id="verAudiencia" class="row">
            <div class=" panel panel-primary">
                <div class="panel-heading">
                    Datos Generales de la Audiencia
                </div>
                <div class="panel-body">
                    <dl class="dl-horizontal">
                        <dt>Fecha y Hora de<br/>Audiencia:</dt> <dd><g:formatDate format="dd/MM/yyyy HH:mm" date="${audiencia.fechaDeAudiencia}"/></dd></dd>
                        <br/>
                        <dt>Tipo de Audiencia:</dt> <dd>${audiencia.tipoDeAudiencia}</dd>
                        <br/>
                        <dt>Asistirá:</dt> <dd>${audiencia.asistente}</dd>
                        <br/>
                        <dt>Usuario que Registró:</dt> <dd>${audiencia.usuarioQueRegistro}</dd>
                        <br/>
                        <dt>Fecha de Registro:</dt> <dd><g:formatDate format="dd/MM/yyyy HH:mm" date="${audiencia.fechaDeRegistro}"/></dd></dd>
                        <br/>
                        <dt>Acciones:</dt> <dd><p style="word-wrap: break-word;">${audiencia.acciones}</p></dd>
                        <br/>
                        <dt>Resultado:</dt> <dd><p style="word-wrap: break-word;">${audiencia.resultado}</p></dd>
                        <br/>
                        <dt>Cancelada:</dt> <dd><span class="badge <g:if test="${audiencia.cancelada}">badge-danger"></g:if><g:else>badge-primary"></g:else>${(audiencia.cancelada) ? "SI" : "NO" }</span></dd>
                            <br/>
                                <dt>Diferida:</dt> <dd><span class="badge <g:if test="${audiencia.reprogramada}">badge-danger"></g:if><g:else>badge-primary"></g:else>${(audiencia.reprogramada) ? "SI" : "NO" }</span></dd>                     
                        </dl>
                    </div>
                </div>
            <g:if test="${audiencia.reprogramada}">
                <div class=" panel panel-info">
                    <div class="panel-heading">
                        Audiencia Reprogramada
                    </div>
                    <div class="panel-body">
                        <dl class="dl-horizontal">                            
                            <dt>Motivo:</dt> <dd><p style="word-wrap: break-word;">${audiencia.motivoDeReprogramacion}</p></dd>
                                <g:if test="${reprogramada}">
                                <br />
                                <dt>Nueva Fecha y Hora<br/>de Audiencia:</dt> <dd><g:formatDate format="dd/MM/yyyy HH:mm" date="${reprogramada?.fechaDeAudiencia}"/></dd></dd>
                                <br/>
                                <dt>Asistirá:</dt> <dd>${reprogramada?.asistente}</dd>
                            </g:if>
                        </dl>
                    </div>
                </div>
            </g:if>
        </div>
        <div id="editarAudiencia" class="row" style="display:none;">
            <div class="col-md-12">
                <g:form class="form-horizontal" id="editarAudienciaForm" name="editarAudienciaForm">
                    <input type="hidden" name="audienciaId" id="audienciaId" value="${audiencia.id}"/>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <label>Acciones *</label>
                                <div class="input-group">
                                    <textarea rows="4" cols="80" style="width: 350px;" id="accionesAudiencia" name='accionesAudiencia' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" >${audiencia.acciones}</textarea> 
                                </div>  
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <label>Resultado *</label>
                                <div class="input-group">
                                    <textarea rows="4" cols="80" style="width: 350px;" id="resultadoAudiencia" name='resultadoAudiencia' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase">${audiencia.resultado}</textarea> 
                                </div>  
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="checkbox checkbox-info checkbox-circle">
                                    <input id="checkbox8" type="checkbox" name="diferirAudiencia" id="diferirAudiencia" onchange="mostrarOcultarMotivo();">
                                    <label for="checkbox8">
                                        <strong>Diferir</strong>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="reprogramacion" style="display: none;">
                        <div id="motivoReprogramacion" class="row" >
                            <div class="form-group">
                                <div class="col-md-12">
                                    <label>Motivo de Reprogramación *</label>
                                    <div class="input-group">
                                        <textarea rows="4" cols="80" style="width: 350px;" id="motivo" name='motivo' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                                    </div>  
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" id="data_1">
                                    <label>Nueva Fecha de Audiencia *</label>
                                    <div id="divFechaAud" class="input-group date datepicker">
                                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 255px;text-align: center;" readOnly name="fechaAud" id="fechaAud" type="text" class="form-control" value="${formatDate(format:'dd/MM/yyyy',date:audiencia.fechaDeAudiencia)}">
                                    </div>
                                </div>  
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group" id="data_1">
                                    <label>Nueva Hora de Audiencia *</label>
                                    <div class="input-group clockpicker">
                                        <span class="input-group-addon">
                                            <span class="fa fa-clock-o"></span>
                                        </span>
                                        <input type="text" style="width: 255px;text-align: center;"  class="form-control"  name="hora" id="hora" readOnly>
                                    </div>
                                </div>  
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <label>Asistente *</label>
                                    <div class="input-group">
                                        <input id="nombreAsistente" name="nombreAsistente" maxlength="80" required style="width: 300px; text-transform: uppercase" type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" value="${audiencia.asistente}">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="form-group">
                                <!--<g:submitToRemote onSuccess="mostrarAudiencia(data);ocultarModal('modalDetalleAudiencia');" onFailure="alert('algo fallo');" onComplete="" class="btn btn-primary" url="[controller: 'audienciaJuicio',action: 'update']" method="POST" value="Actualizar"/>-->
                                <button type="submit" class="btn btn-primary">Actualizar</button>
                            </div>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
        <g:if test="${audiencia.cancelada == false && audiencia.juicio.estadoDeJuicio.id == 1}">
            <div id="btnDetalles" class="row">
                <div class="col-md-12">
                    <div class="form-group">
                        <button type="button" class="btn btn-danger" onclick="cancelarAudiencia(${audiencia.id});"><i class="fa fa-times"></i>&nbsp;&nbsp;<span class="bold">Cancelar Audiencia</span></button>
                        <button type="button"  class="btn btn-primary" onclick="editarAudiencia();"><i class="fa fa-edit"></i>&nbsp;&nbsp;<span class="bold">Editar Audiencia</span></button>
                    </div>
                </div>
            </div>
        </g:if>
    </div>
</g:if>