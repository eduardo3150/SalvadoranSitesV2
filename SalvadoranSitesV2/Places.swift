//
//  Places.swift
//  SalvadoranSitesV2
//
//  Created by Eduardo Chavez on 5/11/17.
//  Copyright © 2017 Eduardo Chavez. All rights reserved.
//

import Foundation
import MapKit

class Places {
    var nombre:String?
    var descripcion:String?
    var coord:MKPointAnnotation?
    var categoria:String?
    
    init(nombre:String, descripcion:String, coord:MKPointAnnotation, categoria: String){
        self.nombre = nombre
        self.descripcion = descripcion
        self.coord = coord
        self.categoria = categoria
    }
}
