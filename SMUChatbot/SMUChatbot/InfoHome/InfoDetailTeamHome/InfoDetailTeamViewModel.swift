import Kingfisher

class InfoDetailTeamViewModel {
    let info = detailTeamInfo
    
    func downloadImage(urlString: String) -> ImageResource? {
        guard let url = URL(string: urlString) else { return nil }
        return ImageResource(downloadURL: url)
    }
    
    func changePage(next: Int) -> Bool {
        return next == info.count ? false : true
    }
}
