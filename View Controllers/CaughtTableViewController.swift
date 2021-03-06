import UIKit

class CaughtTableViewController: UITableViewController {
    var caught: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let person = User()
        WebServices.shared.getObjects(person) { (objects, error) in
            if let objects = objects {
                self.caught = objects
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return caught.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as? PersonCell {
            
            let person = caught[indexPath.row]
            cell.setupCell(person: person)
            
            return cell
        } else {
            print("Error")
            return UITableViewCell()
            
            
        }
    }
}
