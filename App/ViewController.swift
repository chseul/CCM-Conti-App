import UIKit
import Capacitor
import WebKit

class ViewController: CAPBridgeViewController, UIGestureRecognizerDelegate {
    
    var scrollToTopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // WebView가 이미 view에 포함되어 있으므로 addSubview는 제거
        guard let webView = self.bridge?.webView as? WKWebView else { return }

        // 이미 추가된 webView의 제약 조건만 설정
        webView.translatesAutoresizingMaskIntoConstraints = false

//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
//        ])

        // 스와이프 제스처 (뒤로가기)
        let swipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.edges = .left
        swipeGesture.delegate = self
        webView.addGestureRecognizer(swipeGesture)
        
        // 확대/축소 허용 설정
        webView.scrollView.minimumZoomScale = 1.0
        webView.scrollView.maximumZoomScale = 3.0
        webView.scrollView.bouncesZoom = true
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.isUserInteractionEnabled = true
        
        setupScrollToTopButton()
    }

    @objc func handleSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            if let webView = self.bridge?.webView as? WKWebView, webView.canGoBack {
                webView.goBack()
            }
        }
    }
    func setupScrollToTopButton() {
            scrollToTopButton = UIButton(type: .system)
            scrollToTopButton.setTitle("↑", for: .normal)
            scrollToTopButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            scrollToTopButton.backgroundColor = UIColor.systemIndigo
            scrollToTopButton.setTitleColor(.white, for: .normal)
            scrollToTopButton.layer.cornerRadius = 10
            scrollToTopButton.clipsToBounds = true
            scrollToTopButton.translatesAutoresizingMaskIntoConstraints = false
            scrollToTopButton.addTarget(self, action: #selector(scrollToTopTapped), for: .touchUpInside)

            view.addSubview(scrollToTopButton)

            NSLayoutConstraint.activate([
                scrollToTopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                scrollToTopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
                scrollToTopButton.widthAnchor.constraint(equalToConstant: 40),
                scrollToTopButton.heightAnchor.constraint(equalToConstant: 40)
            ])
        }

        @objc func scrollToTopTapped() {
            if let webView = self.bridge?.webView as? WKWebView {
                let js = "window.scrollTo({ top: 0, behavior: 'smooth' });"
                webView.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    
}
