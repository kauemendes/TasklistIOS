//
//  TaskListTableViewController.swift
//  Tasklist
//
//  Created by Kaue Mendes on 4/14/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit

import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate  {

    var manageObjectContext: NSManagedObjectContext?
    var fetchedResultController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCoreDataStack()
        
        self.preLoadDatabase()
        self.getFetchedResultController()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func preLoadDatabase(){
        //carrega somente se o banco nunca foi pre carregado
        if (NSUserDefaults.standardUserDefaults().objectForKey("bancoJaCarregado") == nil) {
            
            let entityDescripition = NSEntityDescription.entityForName("Status", inManagedObjectContext: manageObjectContext!)
            
            let status1 = Status(entity: entityDescripition!, insertIntoManagedObjectContext: manageObjectContext)
            status1.tipo = "a fazer"
            
            let status2 = Status(entity: entityDescripition!, insertIntoManagedObjectContext: manageObjectContext)
            status2.tipo = "em progresso"
            
            let status3 = Status(entity: entityDescripition!, insertIntoManagedObjectContext: manageObjectContext)
            status3.tipo = "completa"
            
            manageObjectContext!.save(nil)
            
            NSUserDefaults.standardUserDefaults().setValue("S", forKey: "bancoJaCarregado")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        let numbersOfRowsInSection = fetchedResultController.fetchedObjects?.count
        
        return numbersOfRowsInSection!
    }
    
    
    // Esse Func responsavel por criar o CORE DATA
    func setupCoreDataStack() {
        // Criação do modelo
        let modelURL:NSURL? = NSBundle.mainBundle().URLForResource("TaskListModel", withExtension: "momd")
        
        let model = NSManagedObjectModel(contentsOfURL: modelURL!)
        
        // Criação do coordenador
        // INSTANCIAR um coordinator associado ao model ja criado
        var coordinator = NSPersistentStoreCoordinator(managedObjectModel: model!)
        
        
        // Pegar o caminho para a pasta documents do sistema
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let applicationDocumentDirectory = urls.last as! NSURL
        
        // Criar uma URL do caminho da pasta documents + o nome do arquivo de banco de dados
        let url = applicationDocumentDirectory.URLByAppendingPathComponent("TaskListModel.sqlite")
        var error:NSError? = nil
        NSLog("%@", url)
        
        
        // associar o arquivo de persistencia com o coordinator, especificado o tipo (SQLLITE)
        var store = coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error)
        
        //se ocorrer um erro na criacao do arquivo de persistencia, logar
        if store == nil {
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            return
        }
        
    // Criação do Contexto
        manageObjectContext = NSManagedObjectContext()
        manageObjectContext!.persistentStoreCoordinator = coordinator
        
    }
    
    func getFetchedResultController() {
        //Primeiro inicializamos um FetchRequest com dados da tabela Task
        let fetchRequest = NSFetchRequest( entityName: "Task")
        
        // Definimos que o campo usado para ordenação será "nome”
        let sortDescriptor = NSSortDescriptor(key: "nome", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
    
        
        //cria um predicao que seleciona só o status com tipo 'completa’
//        fetchRequest.predicate = NSPredicate(format: "status.tipo like 'completa'")
        
        //Iniciamos a propriedade fetchedResultController com uma instância de  NSFetchedResultsController
        //com o FetchRequest acima definido e sem opções de cache
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: manageObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        
        //a controller será o delegate do fetch”
        fetchedResultController.delegate = self
        
        //Executa o Fetch
        fetchedResultController.performFetch(nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIndentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        let task = fetchedResultController.objectAtIndexPath(indexPath) as! Task
        cell.textLabel?.text = task.nome
        

        return cell
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            // Pega o item swiped
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
            
            // E manda deletar pelo objeto
            manageObjectContext?.deleteObject(managedObject)
            
            // Commita alteracao
            manageObjectContext?.save(nil)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
        
        }

    
    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("prepareForItemAdd", sender: indexPath)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        let taskController:TaskDetailViewController = segue.destinationViewController as! TaskDetailViewController
       
        
        taskController.managedObjectContext = manageObjectContext
        
    }

    @IBAction func addItem(sender: AnyObject) {
        performSegueWithIdentifier("prepareForItemAdd", sender: sender)
    }
}
