import Kingfisher

class InfoDetailUseViewModel {
    enum Page {
        case chatViewController
        case inPage
        case popViewController
    }
    
    let info = detailUseInfo
    
    func downloadImage(urlString: String) -> ImageResource? {
        guard let url = URL(string: urlString) else { return nil }
        let resource = ImageResource(downloadURL: url)
        return resource
    }
    
    func changePage(next: Int) -> Page {
        if next < info.count && next >= 0 {
            return .inPage
        } else if next == -1 {
            return .popViewController
        } else {
            return .chatViewController
        }
    }
}
