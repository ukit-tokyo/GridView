//
//  GridViewController.swift
//  GridView
//
//  Created by Taichi Yuki on 2024/04/22.
//

import UIKit
import SnapKit

final class GridViewController: UIViewController, GridViewDataSource {
  private lazy var gridView = GridView(layout: .init(inset: .init(top: 8, left: 8, bottom: 8, right: 8), horizontalSpacing: 8, verticalSpacing: 8))

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "GridView"
    view.backgroundColor = .white

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      systemItem: .refresh,
      primaryAction: UIAction { [weak self] _ in
        self?.gridView.reloadData()
      })

    view.addSubview(gridView)
    gridView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
      make.left.right.equalToSuperview().inset(16)
    }

    gridView.dataSource = self

    gridView.reloadData()
  }

  func gridViewNumberOfColumns(_ gridView: GridView) -> Int {
    3
  }

  func gridViewNumberOfItems(_ gridView: GridView) -> Int {
    14
  }

  func gridView(_ gridView: GridView, viewForItemAt index: Int) -> UIView {
    Card()
  }
}

// MARK: -

protocol GridViewItemComponent where Self: UIView {}

class GridView: UIView {

  struct Layout {
    var inset: UIEdgeInsets = .zero
    var horizontalSpacing = 0
    var verticalSpacing = 0
  }

  weak var dataSource: GridViewDataSource?
  weak var delegate: GridViewDelegate?

  private let contentView = UIView()

  private let layout: Layout

  init(layout: Layout) {
    self.layout = layout
    super.init(frame: .null)

    contentView.backgroundColor = .clear
    addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(layout.inset)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func reloadData() {
    resetLayout()

    guard let dataSource else { return }
    let columnCount = dataSource.gridViewNumberOfColumns(self)
    let itemCount = dataSource.gridViewNumberOfItems(self)

    var prevView: UIView?

    for index in 0 ..< itemCount {

      let columnNumber = index % columnCount
      let rowNumber = index / columnCount

      let view = dataSource.gridView(self, viewForItemAt: index)
      contentView.addSubview(view)

      view.snp.makeConstraints { make in
        guard let prevView else {
          make.top.left.equalToSuperview(); return
        }

        make.size.equalTo(prevView)

        if index == itemCount - 1 {
          make.bottom.equalToSuperview()
        }
        if rowNumber == 0 {
          make.top.equalToSuperview()
          make.left.equalTo(prevView.snp.right).offset(layout.horizontalSpacing)
        } 
        else if columnNumber == 0 {
          make.top.equalTo(prevView.snp.bottom).offset(layout.verticalSpacing)
          make.left.equalToSuperview()
        } 
        else if columnNumber == columnCount - 1 {
          make.top.equalTo(prevView)
          make.left.equalTo(prevView.snp.right).offset(layout.horizontalSpacing)
          make.right.equalToSuperview()
        } else {
          make.top.equalTo(prevView)
          make.left.equalTo(prevView.snp.right).offset(layout.horizontalSpacing)
        }
      }

      prevView = view
    }
  }

  private func resetLayout() {
    contentView.subviews.forEach { subview in
      subview.snp.removeConstraints()
      subview.removeFromSuperview()
    }
  }
}

protocol GridViewDataSource: NSObject {
  func gridViewNumberOfColumns(_ gridView: GridView) -> Int
  func gridViewNumberOfItems(_ gridView: GridView) -> Int
  func gridView(_ gridView: GridView, viewForItemAt index: Int) -> UIView
}
protocol GridViewDelegate: NSObject {
  func gridView(_ gridView: GridView, didSelectItemAt indexPath: Int)
}

// MARK: -

final class Card: UIView, GridViewItemComponent {
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray.withAlphaComponent(0.3)

    let imageView = UIImageView()
    imageView.backgroundColor = .gray
    imageView.layer.cornerRadius = 16

    let titleLabel = UILabel()
    titleLabel.text = "title"
    titleLabel.textColor = .label
    titleLabel.font = .boldSystemFont(ofSize: 12)

    let subtitleLabel = UILabel()
    subtitleLabel.text = "subtitle"
    subtitleLabel.textColor = .label
    subtitleLabel.font = .systemFont(ofSize: 12)

    let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel])
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.distribution = .fill

    addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    imageView.snp.makeConstraints { make in
      make.width.equalTo(imageView.snp.height)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
