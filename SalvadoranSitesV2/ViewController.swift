//
//  ViewController.swift
//  SalvadoranSitesV2
//
//  Created by Eduardo Chavez on 5/10/17.
//  Copyright © 2017 Eduardo Chavez. All rights reserved.
//

import UIKit
import MapKit



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var places:[Places] = [Places]()
    var gralPlaces:[Places] = [Places]()
    var categoriaBandera:String = ""
    
    @IBOutlet weak var categorySelector: UISegmentedControl!
    @IBOutlet weak var selectionLabel: UILabel!
    @IBOutlet weak var tableSitios: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectionLabel.text = "Sitio Arqueologico"
        categoriaBandera = "Sitio Arqueologico"
        loadData()
        self.tableSitios.delegate = self
        self.tableSitios.dataSource = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        arrayLoader()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let requestURL: NSURL = NSURL(string: "https://gist.githubusercontent.com/eduardo3150/e7941517f9f53f4ebc1f8003b2d04682/raw/bdd07d0239e2eaf685b8f651acef1b8ec0e456c9/Salvadoran.json")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                print("Everyone is fine, file downloaded successfully.")
                
                do{
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    
                    if let sitios = json["sitios"] as? [[String: AnyObject]] {
                        
                        for sitio in sitios {
                            
                            if let placeNombre = sitio["nombre"] as? String {
                                
                                if let placeDescripcion = sitio["descripcion"] as? String {
                                    
                                    if let placeCategoria = sitio["categoria"] as? String {
                                        
                                            if let placeLatitud = sitio["latitud"] as? Double {
                                                
                                                if let placeLongitud = sitio["longitud"] as? Double {
                                                    
                                                    let coordenada = MKPointAnnotation()
                                                    coordenada.coordinate = CLLocation(latitude: placeLatitud, longitude: placeLongitud).coordinate
                                                    coordenada.title = placeNombre
                                                    coordenada.subtitle = "Latitud: \(placeLatitud)  Longitud: \(placeLongitud)"
                                                    self.gralPlaces.append(Places(nombre: placeNombre, descripcion: placeDescripcion, coord: coordenada, categoria: placeCategoria))
                                                }
                                            }
                                        }
                                    }
                            
                            }
                        }
                    self.arrayLoader()
                        }
                    
                }catch {
                    print("Error with Json: \(error)")
                }
                
            }
        }
        task.resume()

    }
    
    
    func arrayLoader(){
        self.places.removeAll()
        for place in gralPlaces {
            if place.categoria == categoriaBandera {
                let newName = place.nombre
                let newDesc = place.descripcion
                let newCoor = place.coord
                let newCat  = place.categoria
                self.places.append(Places(nombre: newName!, descripcion: newDesc!, coord: newCoor!, categoria: newCat!))
                
            }
        
        }
        self.tableSitios.reloadData()
    }
    

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.places.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableSitios.dequeueReusableCellWithIdentifier("celdaSitios", forIndexPath: indexPath) as UITableViewCell
        
        let tmpPlaces:Places = places[indexPath.row]
        
        cell.textLabel?.text = "\(tmpPlaces.nombre!)"     
        
        return cell
        
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    
    }

    @IBAction func selectCategory(sender: UISegmentedControl) {
        switch categorySelector.selectedSegmentIndex  {
        case 0:
            categoriaBandera = "Sitio Arqueologico"
            selectionLabel.text = categoriaBandera
            arrayLoader()
            self.tableSitios.reloadData()
        case 1:
            categoriaBandera = "Bosques y Parques"
            selectionLabel.text = categoriaBandera
            arrayLoader()
            self.tableSitios.reloadData()
            
        case 2:
            categoriaBandera = "Lagos y Lagunas"
            selectionLabel.text = categoriaBandera
            arrayLoader()
            self.tableSitios.reloadData()
        case 3:
            categoriaBandera = "Playas"
            selectionLabel.text = categoriaBandera
            arrayLoader()
            self.tableSitios.reloadData()
        default:
            break
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showPlaces") {
            let mapasViewController:MapasViewController = segue.destinationViewController as! MapasViewController
            mapasViewController.places = self.places
        }
    }
    
    

}

