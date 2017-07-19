<div class="row">
    <div class="col-lg-12">
        <div class="ibox chat-view">
            <div class="ibox-title">
                Listado de Notas
            </div>
            <div class="ibox-content">
                <div class="row">
                    <div class="col-lg-12 ">
                        <div class="chat-discussion">
                            <g:each var='resp' in='${respuesta}'>
                                <div class="chat-message left">
                                    <img src="/sicj/assets/chat.png" class="message-avatar">
                                    <div class="message">
                                        <span class="message-content">
                                            ${resp.nota}
                                        </span>
                                        <br />
                                        <p style="font-size: 10px;"> REALIZADA POR:  <strong class="message-author" >${resp.usuario.nombre} ${resp.usuario.apellidoPaterno} ${resp.usuario.apellidoMaterno}</strong>
                                        <span class="message-date"> FECHA: <g:formatDate format="dd/MM/yyyy HH:mm" date="${resp.fechaDeNota}"/> </span></p>
                                    </div>
                                </div>
                            </g:each>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>