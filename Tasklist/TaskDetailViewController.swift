//
//  TaskDetailViewController.swift
//  Tasklist
//
//  Created by Kaue Mendes on 4/14/15.
//  Copyright (c) 2015 Fellas Group. All rights reserved.
//

import UIKit
import CoreData


class TaskDetailViewController: UIViewController{
    
    var managedObjectContext: NSManagedObjectContext?
//    var Task: NSFetchedResultsController?
    var indexItemPath : AnyObject?

    @IBOutlet weak var txtItem: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        println("Mandei o contexto do baguiu \(fetchedResultController)")
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editAddItem(sender: AnyObject) {
        // Adicionar item no banco
        
        // Criar Variavel para referenciar a tabela Task
        let entityDescription = NSEntityDescription.entityForName("Task", inManagedObjectContext: managedObjectContext!)
        
        
        // Criar uma "Task", associado com a entidade correta e colocar no contexto:
        let task = Task(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)

        
        // Alterar o nome da task para o texto colocado no TextField
        task.nome = txtItem.text
        
        // Salvar a alteracao no banco
        managedObjectContext!.save(nil)
        
        
        // Depois de salvar, voltar para a viewController anterior
        navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
