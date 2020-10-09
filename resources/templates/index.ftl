<#-- @ftlvariable name="data" type="ch.exasoft.geoservices.IndexData" -->
<!doctype html>
<html lang="en">
<head>
    <title>Fix for DJI Camera GPS Altitude Error</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
</head>
<body>

<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
</body>
</html>

<html>
<body>

<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark static-top">
    <div class="container">
        <a class="navbar-brand" href="#">geoservices by exasoft</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive"
                aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarResponsive">
            <#--            <ul class="navbar-nav ml-auto">-->
            <#--                <li class="nav-item active">-->
            <#--                    <a class="nav-link" href="#">Home-->
            <#--                        <span class="sr-only">(current)</span>-->
            <#--                    </a>-->
            <#--                </li>-->
            <#--                <li class="nav-item">-->
            <#--                    <a class="nav-link" href="#">About</a>-->
            <#--                </li>-->
            <#--                <li class="nav-item">-->
            <#--                    <a class="nav-link" href="#">Services</a>-->
            <#--                </li>-->
            <#--                <li class="nav-item">-->
            <#--                    <a class="nav-link" href="#">Contact</a>-->
            <#--                </li>-->
            <#--            </ul>-->
        </div>
    </div>
</nav>

<!-- Page Content -->
<div class="container">
    <div class="row">
        <div class="col-lg-4 text-left">
            <h4 class="mt-5">Fix altitude errors in image exif data recorded by DJI cameras.</h4>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-4 text-left">
            <h5 class="mt-5">Non RTK drones</h5>
            <form action="convert" method="post" id="fixAltitudeErrorForm">

                <div class="form-group">
                    <label for="latitudeWGS84">Latitude of take of position in WGS84 Geo Coordinate System</label>
                    <input type="text"
                           class="form-control" name="latitudeWGS84" id="latitudeWGS84" aria-describedby="helpId"
                           placeholder="46.73753153" value="${latitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the latitude of the position where the drone
                                                                    took of. This
                                                                    is usualy the first image captured from the
                                                                    camera.</small>
                </div>
                <div class="form-group">
                    <label for="longitudeWGS84">Longitude of take of position in WGS84 Geo Coordinate System</label>
                    <input type="text"
                           class="form-control" name="longitudeWGS84" id="longitudeWGS84" aria-describedby="helpId"
                           placeholder="7.62752531" value="${longitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the longitude of the position where the drone
                                                                    took of.
                                                                    This
                                                                    is usualy the first image captured from the
                                                                    camera.</small>
                </div>
                <div class="form-group">
                    <label for="altitudeAGL">Mission flight height [m AGL]</label>
                    <input type="text"
                           class="form-control" name="altitudeAGL" id="altitudeAGL" aria-describedby="helpId"
                           placeholder="50" value="${altitudeAGL}">
                    <small id="helpId" class="form-text text-muted">Enter the AGL of the mission at the take of
                                                                    position.
                    </small>
                </div>
                <div class="form-group">
                    <label for="altitudeWGS84">Altitude taken from image exif data recorded by camera in WGS84 Geo
                                               Coordinate System [m ASL]</label>
                    <input type="text"
                           class="form-control" name="altitudeWGS84" id="altitudeWGS84" aria-describedby="helpId"
                           placeholder="512.150" value="${altitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the altitude the camera has written into the
                                                                    image exif data you want to fix. Typically this is
                                                                    the absolute mission altitude at take of
                                                                    position.
                    </small>
                </div>

            </form>

        </div>
        <div class="col-lg-2 text-center d-flex align-items-center">
            <button type="submit" form="fixAltitudeErrorForm" class="btn btn-primary">Submit</button>
        </div>
        <div class="col-lg-4 text-left">

            <#if hasResult && !hasError>
                <h4 class="mt-5">Calculated correction value</h4>
                <div class="form-group">
                    <label for="altitudeCorrection">Calculated correction value</label>
                    <div class="alert alert-success">
                        The correction value is <strong>${altitudeDiff} m</strong>
                    </div>
                    <small id="helpId" class="form-text text-muted">Calculated correction value you can enter for
                                                                    example in
                                                                    the 'Geoid Height Above WGS84 Ellipsoid' in
                                                                    pix4Dmapper as show below in the
                                                                    screenshots. </small>
                </div>
            <#elseif hasError>
                <h4 class="mt-5">Calculated correction value</h4>
                <div class="form-group">
                    <label for="altitudeCorrection">Calculated correction value</label>
                    <div class="alert alert-warning">
                        <strong>OOPS!</strong> something went wrong. Check your input parameter.
                    </div>
                </div>
            </#if>

        </div>
    </div>
    <div class="row">
        <div class="col-lg-4 text-left">
            <h5 class="mt-5">Non RTK drones</h5>
            <form action="convert1" method="post" id="fixAltitudeErrorForm1">
                <div class="form-group">
                    <label for="latitudeWGS84">Latitude of take of position in WGS84 Geo Coordinate System</label>
                    <input type="text"
                           class="form-control" name="latitudeWGS84" id="latitudeWGS84" aria-describedby="helpId"
                           placeholder="46.73753153" value="${latitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the latitude of the position where the drone
                                                                    took of. This
                                                                    is usualy the first image captured from the
                                                                    camera.</small>
                </div>
                <div class="form-group">
                    <label for="longitudeWGS84">Longitude of take of position in WGS84 Geo Coordinate System</label>
                    <input type="text"
                           class="form-control" name="longitudeWGS84" id="longitudeWGS84" aria-describedby="helpId"
                           placeholder="7.62752531" value="${longitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the longitude of the position where the drone
                                                                    took of.
                                                                    This
                                                                    is usualy the first image captured from the
                                                                    camera.</small>
                </div>

                <div class="form-group">
                    <label for="altitudeLN02">Height above see level in LN02 [m.ü.M]</label>
                    <input type="text"
                           class="form-control" name="altitudeLN02" id="altitudeLN02" aria-describedby="helpId"
                           placeholder="50" value="${altitudeLn02}">
                    <small id="helpId" class="form-text text-muted">Enter the meter above see level in LN02 of the mission at the take of
                                                                    position.
                    </small>
                </div>
                <div class="form-group">
                    <label for="altitudeAGL">Mission flight height [m AGL]</label>
                    <input type="text"
                           class="form-control" name="altitudeAGL" id="altitudeAGL" aria-describedby="helpId"
                           placeholder="50" value="${altitudeAGL}">
                    <small id="helpId" class="form-text text-muted">Enter the AGL of the mission at the take of
                                                                    position.
                    </small>
                </div>
                <div class="form-group">
                    <label for="altitudeWGS84">Altitude taken from image exif data recorded by camera in WGS84 Geo
                                               Coordinate System [m ASL]</label>
                    <input type="text"
                           class="form-control" name="altitudeWGS84" id="altitudeWGS84" aria-describedby="helpId"
                           placeholder="512.150" value="${altitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the altitude the camera has written into the
                                                                    image exif data you want to fix. Typically this is
                                                                    the absolute mission altitude at take of
                                                                    position.
                    </small>
                </div>
            </form>

        </div>
        <div class="col-lg-2 text-center d-flex align-items-center">
            <button type="submit" form="fixAltitudeErrorForm1" class="btn btn-primary">Submit</button>
        </div>
        <div class="col-lg-4 text-left">

            <#if hasResult && !hasError>
                <h4 class="mt-5">Calculated correction value</h4>
                <div class="form-group">
                    <label for="altitudeCorrection">Calculated correction value</label>
                    <div class="alert alert-success">
                        The correction value is <strong>${altitudeDiff} m</strong>
                    </div>
                    <small id="helpId" class="form-text text-muted">Calculated correction value you can enter for
                                                                    example in
                                                                    the 'Geoid Height Above WGS84 Ellipsoid' in
                                                                    pix4Dmapper as show below in the
                                                                    screenshots. </small>
                </div>
            <#elseif hasError>
                <h4 class="mt-5">Calculated correction value</h4>
                <div class="form-group">
                    <label for="altitudeCorrection">Calculated correction value</label>
                    <div class="alert alert-warning">
                        <strong>OOPS!</strong> something went wrong. Check your input parameter.
                    </div>
                </div>
            </#if>

        </div>
    </div>
    <div class="row">
        <div class="col-lg-4 text-left">
            <h5 class="mt-5">RTK drones</h5>
            <form action="convertRTK" method="post" id="fixAltitudeErrorFormRTK">

                <div class="form-group">
                    <label for="latitudeWGS84">Latitude of take of position in WGS84 Geo Coordinate System</label>
                    <input type="text"
                           class="form-control" name="latitudeWGS84" id="latitudeWGS84" aria-describedby="helpId"
                           placeholder="46.73753153" value="${latitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the latitude of the position where the drone
                                                                    took of. This is usualy the first image captured
                                                                    from the camera.</small>
                </div>
                <div class="form-group">
                    <label for="longitudeWGS84">Longitude of take of position in WGS84 Geo Coordinate System</label>
                    <input type="text"
                           class="form-control" name="longitudeWGS84" id="longitudeWGS84" aria-describedby="helpId"
                           placeholder="7.62752531" value="${longitudeWGS84}">
                    <small id="helpId" class="form-text text-muted">Enter the longitude of the position where the drone
                                                                    took of. This is usualy the first image captured
                                                                    from the camera.</small>
                </div>
            </form>

        </div>
        <div class="col-lg-2 text-center d-flex align-items-center">
            <button type="submit" form="fixAltitudeErrorFormRTK" class="btn btn-primary">Submit</button>
        </div>
        <div class="col-lg-4 text-left">

            <#if hasResultRTK && !hasErrorRTK>
                <h4 class="mt-5">Calculated correction value</h4>
                <div class="form-group">
                    <label for="altitudeCorrection">Calculated correction value</label>
                    <div class="alert alert-success">
                        The correction value is <strong>${altitudeDiff} m</strong>
                    </div>
                    <small id="helpId" class="form-text text-muted">Calculated correction value you can enter for
                                                                    example in
                                                                    the 'Geoid Height Above WGS84 Ellipsoid' in
                                                                    pix4Dmapper as show below in the
                                                                    screenshots. </small>
                </div>
            <#elseif hasErrorRTK>
                <h4 class="mt-5">Calculated correction value</h4>
                <div class="form-group">
                    <label for="altitudeCorrection">Calculated correction value</label>
                    <div class="alert alert-warning">
                        <strong>OOPS!</strong> something went wrong. Check your input parameter.
                    </div>
                </div>
            </#if>

        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 mt-2 text-left">
            <img src="../static/screen-pix4Dmapper-image-property-editor.png" class="img-fluid rounded-top"
                 alt="Scrren of pix4Dmapper Image Propery Editor">
        </div>
    </div>
</div>


</body>
</html>
