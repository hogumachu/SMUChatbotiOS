import Kingfisher

class InfoDetailTeamViewModel {
    let info = detailTeamInfo
    
    func downloadImage(urlString: String) -> ImageResource? {
        guard let url = URL(string: urlString) else { return nil }
        let resource = ImageResource(downloadURL: url)
        return resource
    }
    func changePage(next: Int) -> Bool {
        if next == info.count {
            return false
        }
        return true
    }
}
