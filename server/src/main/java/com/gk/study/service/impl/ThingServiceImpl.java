package com.gk.study.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.gk.study.entity.Thing;
import com.gk.study.mapper.ThingMapper;
import com.gk.study.service.ThingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ThingServiceImpl extends ServiceImpl<ThingMapper, Thing> implements ThingService {
    @Autowired
    ThingMapper mapper;


    @Override
    public List<Thing> getThingList(String keyword, String sort, String c, String cc) {
        QueryWrapper<Thing> queryWrapper = new QueryWrapper<>();

        // 搜索
        queryWrapper.like(StringUtils.isNotBlank(keyword), "title", keyword);

        // 排序
        if (StringUtils.isNotBlank(sort)) {
            if (sort.equals("recent")) {
                queryWrapper.orderBy(true, false, "create_time");
            } else if (sort.equals("hot") || sort.equals("recommend")) {
                // pv 是 VARCHAR 字符串，直接排序会按字典序（"97" > "143"），必须转成数值再排
                queryWrapper.orderBy(true, false, "CAST(pv AS UNSIGNED)");
            }
        }else {
            queryWrapper.orderBy(true, false, "create_time");
        }

        // 根据分类筛选
        if (StringUtils.isNotBlank(c) && !c.equals("-1")) {
            queryWrapper.eq(true, "classification_id", c);
        }

        // 根据分类2筛选
        if (StringUtils.isNotBlank(cc) && !cc.equals("全部")) {
            queryWrapper.eq(true, "location", cc);
        }

        List<Thing> things = mapper.selectList(queryWrapper);

        return things;
    }

    @Override
    public void createThing(Thing thing) {
        System.out.println(thing);
        thing.setCreateTime(String.valueOf(System.currentTimeMillis()));

        if (thing.getPv() == null) {
            thing.setPv("0");
        }
        if (thing.getScore() == null) {
            thing.setScore("0");
        }
        if (thing.getWishCount() == null) {
            thing.setWishCount("0");
        }
        mapper.insert(thing);
    }

    @Override
    public void deleteThing(String id) {
        mapper.deleteById(id);
    }

    @Override
    public void updateThing(Thing thing) {

        mapper.updateById(thing);
    }

    @Override
    public Thing getThingById(String id) {
        Thing thing = mapper.selectById(id);
        if (thing == null) {
            // 防止传入不存在的 id 时抛 NullPointerException
            return null;
        }

        // 浏览量自增：交给数据库做 "pv = pv + 1"，
        // 避免"读出来 → 内存里 +1 → 整行写回"在并发访问时互相覆盖（丢失计数）。
        // pv 字段是 VARCHAR，先 CAST 成数值再运算；NULL/空串用 COALESCE 兜底，否则 NULL + 1 还是 NULL。
        mapper.update(null, new UpdateWrapper<Thing>()
                .setSql("pv = COALESCE(CAST(pv AS UNSIGNED), 0) + 1")
                .eq("id", id));

        // 重新查一次，把数据库里的最新浏览量返回给前端
        return mapper.selectById(id);
    }

    // 心愿数加1
    @Override
    public void addWishCount(String thingId) {
        Thing thing = mapper.selectById(thingId);
        thing.setWishCount(String.valueOf(Integer.parseInt(thing.getWishCount()) + 1));
        mapper.updateById(thing);
    }

    // 收藏数加1
    @Override
    public void addCollectCount(String thingId) {
        Thing thing = mapper.selectById(thingId);
        thing.setCollectCount(String.valueOf(Integer.parseInt(thing.getCollectCount()) + 1));
        mapper.updateById(thing);
    }

    @Override
    public List<Thing> getUserThing(String userId) {
        QueryWrapper<Thing> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("user_id", userId);
        return mapper.selectList(queryWrapper);
    }

    @Override
    public List<Thing> getThingListByThingIds(List<Long> thingIdList) {
        QueryWrapper<Thing> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("id", thingIdList);
        return mapper.selectList(queryWrapper);
    }

    @Override
    public List<Thing> getDefaultThingList() {
        QueryWrapper<Thing> queryWrapper = new QueryWrapper<>();
        // 同上：pv 是字符串，按数值降序才是真正的"最热"
        queryWrapper.orderByDesc("CAST(pv AS UNSIGNED)");
        return mapper.selectList(queryWrapper);
    }


}
