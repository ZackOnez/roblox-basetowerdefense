local DefaultUserData = {}

-- 玩家默认数据模板
DefaultUserData.Template = {
  -- 金币数量
  Coins = 0,
  -- 钻石数量
  Gems = 0,
  -- 解锁到的关卡
  Level = 1,
  Playtime = 0,
  -- 拥有的默认塔
  OwnedTowers = {
    "Punch","Punch2","Punch3",
    "Sword","Sword2","Sword3",
    "Staff","Staff2","Staff3"
  },
  -- 玩家身份：值1表示=新玩家（需要新手引导）；值2表示老玩家
  PlayerIdentity = 1
}

return DefaultUserData