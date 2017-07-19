<g:if test="${juicio}">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <g:form action="cambiarEstadoJuicio" class="form-horizontal" name="cambiarEstadoJuicioForm">
                        <input type="hidden" name="id" id="juicioTerminadoId" value="${juicio}"/>
                        <input type="hidden" name="estado" id="estadoJuicioTerminadoId" value="${estadoDeJuicio.id}"/>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">Status: </label>
                            <div class="col-sm-9">
                                <input type="text" class="form-control" readonly name='estadoDelJuicio' size='50' value="${estadoDeJuicio.nombre}" maxlength='255' autocomplete='off' onBlur="this.value=this.value.toUpperCase();"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">Observaciones: </label>
                            <div class="col-sm-9">
                                <div class="input-group">
                                    <textarea rows="4" cols="80" style="width: 365px;" id="observacionesFinales" name='observacionesFinales' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                                </div> 
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">Fecha: </label>
                            <div class="col-sm-9">
                                <div id="divfechaDeTermino" class="input-group date datepicker">
                                    <span class="input-group-addon"><i class="fa fa-calendar"></i></span><input readOnly name="fechaDeTermino" id="fechaDeTermino" type="text" class="form-control">
                                </div>
                            </div>
                        </div>
                        <g:if test="${estadoDeJuicio.id == 2 || pagarSinTerminar}">
                            <g:if test="${estadoDeJuicio.id == 2}">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Termino por: </label>
                                    <div class="col-sm-9">
                                        <div class="input-group ">
                                            <g:select noSelection="['':'Elija una opción...']" required style="width: 365px;" data-placeholder="Elija una opción..." class="chosen-select" style="width:365px;" tabindex="2" id="motivoDeTermino" name="motivoDeTermino" from="${motivos}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                            </g:if>
                            <div class="form-group">
                                <label class="col-md-3 control-label">¿Juicio Pagado? </label>
                                <div class="col-md-6">
                                    <div class="radio radio-success radio-inline">
                                        <input type="radio" name="juicioPagado" onclick="mostrarDatosPago();" id="juicioPagadoSI" value="SI">
                                        <label for="respuestaRadioSI">
                                            SI
                                        </label>
                                    </div>
                                    <div class="radio radio-success radio-inline">
                                        <input type="radio" name="juicioPagado" onclick="ocultarDatosPago();" id="juicioPagadoNO" value="NO" checked>
                                        <label for="respuestaRadioNO">
                                            NO
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div id="datosPago">
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Cantidad Pagada: </label>
                                    <div class="col-sm-9">
                                        <input type="number" class="form-control" name='cantidadPagada' id="cantidadPagada" size='50' maxlength='255' autocomplete='off' onBlur="this.value=this.value.toUpperCase();" onKeyPress="return numbersonly(this, event)"/>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-3 control-label">Forma de Pago: </label>
                                    <div class="col-sm-9">
                                        <div class="input-group ">
                                            <g:select noSelection="['':'Elija una opción...']" data-placeholder="Elija una opción..." class="chosen-select" style="width:365px;" tabindex="2" id="formaDePago" name="formaDePago" from="${mx.gox.infonavit.sicj.catalogos.FormaDePago?.list(sort:'nombre')}" optionKey="id" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </g:if>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <div class="col-sm-4 col-sm-offset-2">
                                <button class="btn btn-primary" type="submit">Guardar</button>
                            </div>
                        </div>
                    </g:form>
                </div>
            </div>
        </div>
    </div>
</g:if>