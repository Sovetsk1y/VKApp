//
//  NewsViewController.swift
//  Вконтакте
//
//  Created by Евгений Сивицкий on 19.08.18.
//  Copyright © 2018 Евгений Сивицкий. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    let vkApiService = VKApiService()
    var news: [News] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .none
        self.navigationItem.title = "Загружаем..."
        vkApiService.getNews { (news) in
            self.news = news
            DispatchQueue.main.async {
                self.navigationItem.title = "Новости"
                self.tableView.separatorStyle = .singleLine
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if news.count != 0 {
            return self.news.count + 1
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row >= news.count {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "showMoreCell") as? ShowMoreCell {
                cell.activityIndicator.isHidden = true
                cell.activityIndicator.stopAnimating()
                cell.showMoreLabel.isHidden = false
                cell.showMoreLabel.text = "Показать ещё"
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cellTextImage", for: indexPath) as? NewsTextAndImageCell {
                let news = self.news[indexPath.row]
                cell.avatarImageView.image = news.authorImage
                cell.imageOfNewsImageView.image = news.postImage
                cell.authorLabel.text = news.authorName
                cell.textOfNewsLabel.text = news.postText
                cell.likesLabel.text = String(news.likes)
                cell.commentsLabel.text = String(news.likes)
                cell.repostsLabel.text = String(news.reposts)
                cell.viewsLabel.text = String(news.views)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= news.count {
            if let cell = tableView.cellForRow(at: indexPath) as? ShowMoreCell {
                tableView.deselectRow(at: indexPath, animated: false)
                cell.activityIndicator.startAnimating()
                cell.activityIndicator.isHidden = false
                cell.showMoreLabel.isHidden = true
                
                vkApiService.getNews(completion: { (news) in
                    self.news.append(contentsOf: news)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                })
            }
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
}
