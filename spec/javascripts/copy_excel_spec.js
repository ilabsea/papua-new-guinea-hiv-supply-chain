describe("CopyExcel", function(){
  it("should return list of items", function(){
    copySource = "10  20  30  40  50  \
                  110  110  120  130  140 \
                  200  210  220  230  240"

    result   = [ 
      [10, 20, 30, 40, 50],
      [110, 110, 120, 130, 140 ],
      [200, 210, 220, 230, 240]
    ] 
    itemList = CopyExcel.toItems()
    expect(itemList).toEqual([])

  })
})