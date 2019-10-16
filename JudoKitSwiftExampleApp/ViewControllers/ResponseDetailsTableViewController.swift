import UIKit

class ResponseDetailsTableViewController: UITableViewController {

    let data: [DetailsTableViewSection]

    init(title: String, data: [DetailsTableViewSection]) {
        self.data = data
        super.init(style: .grouped)
        self.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if presentingViewController != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                             target: self,
                                                                             action: #selector(didTapDone))
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "reuseIdentifier"
        let row = data[indexPath.section].rows[indexPath.row]

        let reusableCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        let cell = reusableCell ?? UITableViewCell(style: .value1, reuseIdentifier: identifier)

        cell.selectionStyle = .none
        cell.textLabel?.text = row.title
        cell.detailTextLabel?.text = row.value
        cell.detailTextLabel?.numberOfLines = 0
        cell.isAccessibilityElement = true
        cell.accessibilityIdentifier = row.title

        return cell
    }

    @objc func didTapDone() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }
}
