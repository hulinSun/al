/*
  Two-dimensional array with a fixed number of rows and columns.
  This is mostly handy for games that are played on a grid, such as chess.
  Performance is always O(1).
*/
public struct Array2D<T>: CustomStringConvertible {
  public let columns: Int
  public let rows: Int
  fileprivate var array: [T]

  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(repeating: initialValue, count: rows*columns)
  }

  public subscript(row: Int, column: Int) -> T {
    get {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      return array[row*columns + column]
    }
    set {
      precondition(column < columns, "Column \(column) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      precondition(row < rows, "Row \(row) Index is out of range. Array<T>(columns: \(columns), rows:\(rows))")
      array[row*columns + column] = newValue
    }
  }
    public var description: String {
        var s  = ""
        for i in 0..<rows {
            for j in 0..<columns {
                s += "\t \(self[i,j])"
            }
            s += "\n"
        }
        return s
    }
}
